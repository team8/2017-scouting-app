//
//  ViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 12/5/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDropbox


var previousScreen = "none"
var currentScreen = "menu"

class MenuViewController: ViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var launch = true
    
    @IBOutlet weak var backButton: UIButton!
    var previousViewController: ViewController?
    var hasPrevious = false
    
    @IBOutlet weak var compTextField: UITextField!
    let pickerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
    let doneButton = UIButton(frame: CGRect(x: 220, y: 0, width: 100, height: 50))
    let picker = UIPickerView(frame: CGRect(x: 0, y: 50, width: 320, height: 150))
    
    @IBOutlet var menuButtons: [UIButton]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if previousScreen != "none"{
            previousScreen = currentScreen
        }
        currentScreen = "menu"
    
        //Borders
        for menuButton in menuButtons{
            //Borders
            menuButton.layer.borderWidth = 1
            menuButton.layer.borderColor = UIColor.white.cgColor
        }
        
        //Back button sizing
        backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        //Hide back button
        backButton.isHidden = !self.hasPrevious
        
        //Picker
        if(launch) {
            if let saved = UserDefaults.standard.value(forKey: "competition") as? Int {
                pickerSelect(saved)
            } else {
                pickerSelect(0)
            }
            launch = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compTextField.delegate = self
        self.compTextField.backgroundColor = UIColor.clear
        self.compTextField.tintColor = UIColor.clear
        
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
        
        compTextField.inputView = pickerView
        
    }
    
    //Back button
    @IBAction func backPressed(_ sender: Any) {
        if(self.previousViewController! is TeamViewController) {
            self.performSegue(withIdentifier: "menuToTeam", sender: nil)
        } else if(self.previousViewController! is MatchViewController) {
            self.performSegue(withIdentifier: "menuToMatch", sender: nil)
        } else if(self.previousViewController! is ViewStatsViewController) {
            self.performSegue(withIdentifier: "menuToViewStats", sender: nil)
        } else if(self.previousViewController! is PitScoutingViewController) {
            self.performSegue(withIdentifier: "menuToPitScouting", sender: nil)
        }
//        self.navigationController?.pushViewController(self.previousViewController!, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TeamViewController, segue.identifier == "menuToTeam" {
            let prev = (self.previousViewController! as! TeamViewController)
            vc.teamNumber = prev.teamNumber
            vc.previousViewController = prev.previousViewController
            vc.navigationStack = prev.navigationStack
        } else if let vc = segue.destination as? MatchViewController, segue.identifier == "menuToMatch" {
            let prev = (self.previousViewController! as! MatchViewController)
            vc.match = prev.match
            vc.previousViewController = prev.previousViewController
            vc.navigationStack = prev.navigationStack
        } else if let vc = segue.destination as? ViewStatsViewController, segue.identifier == "menuToViewStats" {
            let prev = (self.previousViewController! as! ViewStatsViewController)
            vc.timd = prev.timd
            vc.previousViewController = prev.previousViewController
            vc.navigationStack = prev.navigationStack
        } else if let vc = segue.destination as? PitScoutingViewController, segue.identifier == "menuToPitScouting" {
            let prev = (self.previousViewController! as! PitScoutingViewController)
            vc.pitScouting = prev.pitScouting
            vc.viewing = prev.viewing
            vc.previousViewController = prev.previousViewController
            vc.navigationStack = prev.navigationStack
        }
        self.hasPrevious = false
    }
    
    //Picker stuff
    func pickerSelect(_ index: Int) {
        if !(index == UserDefaults.standard.value(forKey: "competition") as? Int) {
            self.hasPrevious = false
            backButton.isHidden = true
        }
        compTextField.text = AppDelegate.compList[index]
        Data.competition = AppDelegate.compIDs[index]
        UserDefaults.standard.set(index, forKey: "competition")
        Data.fetchFromCoreData(event: Data.competition!)
    }
    
    func donePressed(sender: UIButton!) {
        pickerSelect(self.picker.selectedRow(inComponent: 0))
        self.compTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AppDelegate.compList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AppDelegate.compList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelect(row)
    }
    
    @IBAction func menuUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
}
