//
//  TSMatchListViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 12/6/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MatchListViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    //    @IBOutlet weak var myButton : UIButton!
    //    @IBOutlet weak var myTextField : UITextField!
    //
    //    @IBAction func myButtonAction(sender: id)
    
    @IBOutlet weak var matchTable: UITableView!
    var matchList = [TBAMatch]()
    override func viewDidLoad() {
        matchTable.dataSource = self
        matchTable.delegate = self
        
        if let alreadySaved = UserDefaults.standard.object(forKey: "alreadySaved"){

        }else{
            print("ran")
            Data.fetch(complete: fetchComplete)
        }
        populateMatchList()

    }
    func populateMatchList() -> Void {
        print("populateMatchList")
        //Populating matchList
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDel.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Matches", in:managedContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if (results.count > 0) {
                if let managedObjectResults = results as? [NSManagedObject]{
                    for i : NSManagedObject in managedObjectResults{
                        let unarchivedData : NSData = i.value(forKey: "match") as! NSData
                        do{
                            let match : NSDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as! NSDictionary
                            let config = match.value(forKey: "config") as! String
                            let blueTeams = match.value(forKey: "blue") as! [String]
                            let redTeams = match.value(forKey: "red") as! [String]
                            let teamToAppend = TBAMatch(keyV: config, blueAlliance: blueTeams, redAlliance: redTeams)
                            print(config)
                            matchList.append(teamToAppend)
                            
                            
                        }catch{
                            print(":(")
                        }
                        
                    }
                }
                
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        DispatchQueue.main.async{
            self.matchTable.reloadData()
        }
        
    }
    @IBAction func refresh(_ sender: UIButton) {
        addActivityIndicator()
        self.view.isUserInteractionEnabled = false
        Data.fetch(complete: fetchComplete)
        
    }
    
    func addActivityIndicator() {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.frame = CGRect(x: 230, y: 30, width: 30, height: 30)
        activityIndicator.tag = 100
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
    }
    
    func removeActivityIndicator() {
        if let activityIndicator = self.view.viewWithTag(100) {
            activityIndicator.removeFromSuperview()
        }
    }
    
    func fetchComplete() {
        self.matchTable.reloadData()
        removeActivityIndicator()
        self.view.isUserInteractionEnabled = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath)
        print("tb-refreshed")
        cell.textLabel?.text = 	matchList[indexPath.row].getKeyAsDisplayable()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchList.count
    }
    public func saveToCoreData(dict: NSMutableDictionary){
        
        //Getting and converting the matchesDict to NSData
        let matchesDict = dict as NSDictionary
        let dataToSave = NSKeyedArchiver.archivedData(withRootObject: matchesDict)
        
        //Getting stuff from the appDelegate
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDel.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Matches", in:managedContext)
        
        //Creating the managed object and saving the match
        let managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
        managedObject.setValue(dataToSave, forKey: "match")
        
        //This will succeed 99% of the time
        do{
            try managedContext.save()
            if (UserDefaults.standard.bool(forKey: "alreadySaved") as? Bool) == nil{
                UserDefaults.standard.set(true, forKey: "alreadySaved")
            }
            populateMatchList()
            
        }catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
    }
    
    func deleteAllData(){
        if (UserDefaults.standard.bool(forKey: "alreadySaved") as? Bool) != nil{
            print("delete ran")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Matches")
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
            } catch let error as NSError {
                print("error : \(error) \(error.userInfo)")
            }
        }
    }
    @IBAction func teamListUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
}
