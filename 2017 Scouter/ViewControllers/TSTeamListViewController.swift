//
//  ViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 12/5/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation
import UIKit

class TeamListViewController: ViewController, UITextFieldDelegate, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
//    @IBOutlet weak var myButton : UIButton!
//    @IBOutlet weak var myTextField : UITextField!
//    
//    @IBAction func myButtonAction(sender: id)
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var sortTextField: UITextField!
    let sortCriteria = ["Team Number", "Ranking"]
    var criteriaIndex = 0
    var sortedTeamList = [Int]()
    let pickerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
    let doneButton = UIButton(frame: CGRect(x: 220, y: 0, width: 100, height: 50))
    let picker = UIPickerView(frame: CGRect(x: 0, y: 50, width: 320, height: 150))
    
    @IBOutlet weak var teamTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Menu Button Image Sizing
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        teamTable.backgroundColor = UIColor.clear
        
//        Data.fetch(complete: fetchComplete)
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamTable.dataSource = self
        teamTable.delegate = self
        
        self.sortTextField.delegate = self
        self.sortTextField.backgroundColor = UIColor.clear
        self.sortTextField.tintColor = UIColor.clear
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        picker.delegate = self
        picker.backgroundColor = UIColor.lightGray
        pickerView.backgroundColor = UIColor.white
        pickerView.addSubview(doneButton)
        pickerView.addSubview(picker)
        
        //        let doneTrailingConstraint = NSLayoutConstraint(item: doneButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: pickerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        //        let doneTopConstraint = NSLayoutConstraint(item: doneButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: pickerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        //
        //        NSLayoutConstraint.activate([doneTrailingConstraint, doneTopConstraint])
        
        sortTextField.inputView = pickerView
    }
    
    //Refresh stuff
    @IBAction func refresh(_ sender: UIButton) {
        addActivityIndicator()
        self.view.isUserInteractionEnabled = false
        Data.fetch(complete: fetchComplete)
        
    }
    
    func refresh() {
        refresh(UIButton())
    }
    
    func addActivityIndicator() {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.frame = CGRect(x: 230, y: 37, width: 30, height: 30)
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
        self.teamTable.reloadData()
        removeActivityIndicator()
        self.view.isUserInteractionEnabled = true
    }
    
    //Table stuff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
        
        //Sorting
        switch(self.criteriaIndex) {
        case 0:
            //Team number
            self.sortedTeamList = Data.teamList.sorted()
            break
        case 1:
            //Ranking
            //temporary reverse sorting
            self.sortedTeamList = Data.teamList.sorted().reversed()
            break
        default:
            break
        }
        
        let teamNumber = self.sortedTeamList[indexPath.row]
        
        cell.teamNum = teamNumber
        cell.rankingNumber.text = "#" + String(indexPath.row + 1)
        cell.teamNumber.text = String(teamNumber)
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TeamTableViewCell
        self.performSegue(withIdentifier: "teamListToTeam", sender: cell.teamNum)
    }

    //Send team number data to team view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "teamListToTeam") {
            let secondViewController = segue.destination as! TeamViewController
            let teamNumber = sender as! Int
            secondViewController.previousViewController = self
            secondViewController.teamNumber = teamNumber
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.teamList.count
    }
    
    //Picker stuff
    func pickerSelect(index: Int) {
        self.sortTextField.text = "Sort by: " + self.sortCriteria[index]
        self.criteriaIndex = index
        self.teamTable.reloadData()
    }
    
    @IBAction func donePressed(sender: UIButton!) {
        pickerSelect(index: self.picker.selectedRow(inComponent: 0))
        self.sortTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortCriteria.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortCriteria[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelect(index: row)
    }

    //Unwind segue
    @IBAction func teamListUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
}
