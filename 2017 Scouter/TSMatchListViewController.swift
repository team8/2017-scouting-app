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
    override func viewWillAppear(_ animated: Bool) {
        //Gradient
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.frame
        let color1 = UIColor(colorLiteralRed: 34/255, green: 139/255, blue: 34/255, alpha: 1).cgColor
        let color2 = UIColor(colorLiteralRed: 17/255, green: 38/255, blue: 11/255, alpha: 1).cgColor
        gradient.colors = [color1, color2] //Or any colors
        self.view.layer.insertSublayer(gradient, at: 0)
        
        matchTable.backgroundColor = UIColor.clear
        
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
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
                            TBAMatch.matchListUnordered.append(teamToAppend)
                            
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
        self.matchList = TBAMatch.orderMatches()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        DispatchQueue.main.async{
            self.matchTable.reloadData()
        }
        
    }

    
    @IBAction func refresh(_ sender: UIButton) {
        addActivityIndicator()
        self.view.isUserInteractionEnabled = false
        Data.fetch(complete: fetchComplete)
        DispatchQueue.main.async{
            self.matchTable.reloadData()
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! UnplayedTableViewCell
        var blueTeamString = ""
        for blueTeamWithFRC in matchList[indexPath.row].blue{
            let blueTeam : String = blueTeamWithFRC.components(separatedBy: "c")[1]
            blueTeamString += blueTeam
            if blueTeamWithFRC != matchList[indexPath.row].blue[matchList[indexPath.row].blue.count - 1]{
                blueTeamString += "\n"
            }

        }
        cell.blueTeams.text = blueTeamString
        
        switch matchList[indexPath.row].matchType{
        case TBAMatch.MatchType.qualifying:
            cell.matchAbbr.text = "QM"
            cell.matchNumber.text = String(matchList[indexPath.row].matchNumber)
            cell.matchIn.text = ""
        case TBAMatch.MatchType.quarterFinal:
             cell.matchAbbr.text = "QF"
             cell.matchNumber.text =  String(matchList[indexPath.row].matchNumber)
             cell.matchIn.text = "Match #" + String(matchList[indexPath.row].matchIn!)

        case TBAMatch.MatchType.semiFinal:
            cell.matchAbbr.text = "SF"
            cell.matchNumber.text =  String(matchList[indexPath.row].matchNumber)
            cell.matchIn.text = "Match #" + String(matchList[indexPath.row].matchIn!)
            
        case TBAMatch.MatchType.final:
            cell.matchAbbr.text = "F"
            cell.matchNumber.text =  String(matchList[indexPath.row].matchNumber)
            cell.matchIn.text = "Match #" + String(matchList[indexPath.row].matchIn!)
            
        default:
            cell.matchAbbr.text = "UNK"
            
        }
        
        
        var redTeamString = ""
        for redTeamWithFRC in matchList[indexPath.row].red{
            let redTeam : String = redTeamWithFRC.components(separatedBy: "c")[1]
            redTeamString += redTeam
            if redTeamWithFRC != matchList[indexPath.row].red[matchList[indexPath.row].red.count - 1]{
                redTeamString += "\n"
            }
        }
        cell.redTeams.text = redTeamString
        
        cell.backgroundColor = UIColor.clear
        
        print("tb-refreshed")
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
