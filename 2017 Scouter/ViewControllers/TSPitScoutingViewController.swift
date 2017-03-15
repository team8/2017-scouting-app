//
//  TSPitScoutingViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PitScoutingViewController: ViewController {
    
    var viewing: Bool?
    
    var pitScouting: PitScouting?
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var teamField: UITextField!
    @IBOutlet weak var teamFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveUploadButton: UIButton!
    
    var previousViewController: ViewController?
    var navigationStack: [UIViewController]?
    
    @IBOutlet var sectionViews: [PitScoutingSectionView]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var sectionVCs = [PSSectionViewController]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Menu Button Image Sizing
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        for view in sectionViews {
            view.parent = self
        }
//        print(self.viewing)
        reload()
        
        if (self.pitScouting!.stats.count != 0) {
            for view in sectionViews {
                view.setEnabled(data: self.pitScouting!.stats)
            }
            for vc in sectionVCs {
                vc.setData(data: self.pitScouting!.stats)
            }
        }
        
        if(self.navigationStack != nil) {
            self.navigationController?.viewControllers = self.navigationStack!
        }
//        self.viewing = false
    }
    
    func reload() {
        if(self.viewing!) {
            titleLabel.text = "View Team"
            teamLabel.text = "Team " + String(pitScouting!.teamNumber!)
            teamFieldWidth.constant = 0
            editButton.setTitle("Edit Data", for: .normal)
            saveUploadButton.setTitle("Upload Data", for: .normal)
            for vc in self.sectionVCs {
                vc.setEnabled(false)
            }
            for view in self.sectionViews {
                view.displayButton.isEnabled = false
            }
        } else {
            titleLabel.text = "Edit Team"
            teamLabel.text = "Team "
            teamFieldWidth.constant = 78
            if (self.pitScouting!.teamNumber == nil) {
                teamField.text = ""
            } else {
                teamField.text = String(self.pitScouting!.teamNumber!)
            }
            editButton.setTitle("", for: .normal)
            saveUploadButton.setTitle("Save Data", for: .normal)
            for vc in self.sectionVCs {
                vc.setEnabled(true)
            }
            for view in self.sectionViews {
                if (view.displayButton.tag != 0 && view.displayButton.tag != 8) {
                    view.displayButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "pitScoutingToMenu", sender: nil)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        if(self.previousViewController! is PitListViewController) {
            self.performSegue(withIdentifier: "unwindPitScoutingToPitList", sender: nil)
        } else if(self.previousViewController! is TeamViewController) {
            self.performSegue(withIdentifier: "unwindPitScoutingToTeam", sender: nil)
        }
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        self.viewing = false
        reload()
    }
    @IBAction func saveUploadPressed(_ sender: Any) {
        if (self.viewing)! {
            let alert = UIAlertController(title: "Upload Confirmation", message: "Are you sure you want to upload this pit scouting data? This will overwrite any previous pit scouting data.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
                ServerInterfacer.uploadPitData(with: self.pitScouting!.stats, callback: self.statusOfSubmission(_:))
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            var data = [String: String]()
            for vc in sectionVCs {
                if (vc.getData() == nil) {
                    let alertController = UIAlertController(title: "Error", message: "Please fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                for (k, v) in vc.getData()! {
                    data.updateValue(v, forKey: k)
                }
            }
            if (teamField.text == "") {
                let alertController = UIAlertController(title: "Error", message: "Please fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.pitScouting!.teamNumber = Int(teamField.text!)
            self.pitScouting!.stats = data
            self.pitScouting!.stats["team_number"] = teamField.text!
            self.pitScouting!.stats["event"] = Data.competition!
            if (Data.getPitScoutingLocal(teamNumber: self.pitScouting!.teamNumber!) == nil) {
                Data.pitScoutingList.append(self.pitScouting!)
            }
//            print(Data.pitScoutingList[0].stats)
//            print(data)
            Data.saveLocalPitScoutingToCoreData()
            self.viewing = true
            reload()
        }
    }
    
    func statusOfSubmission(_ data: Bool) {
        let alert : UIAlertController = UIAlertController(title: "Status", message: "Status: \(data)", preferredStyle: .alert)
        let action : UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        //Send data to embedded view controllers
        if let vc = segue.destination as? PSSectionViewController {
            for view in sectionViews {
                if (view.displayButton.tag == vc.tag) {
                    vc.parentView = view
                }
            }
            self.sectionVCs.append(vc)
//            self.embeddedViewController = vc
//            (self.embeddedViewController?.viewControllers?[0] as! TeamInfoViewController).teamNumber = self.teamNumber
//            (self.embeddedViewController?.viewControllers?[1] as! TeamMatchesViewController).teamNumber = self.teamNumber
//            (self.embeddedViewController?.viewControllers?[1] as! TeamMatchesViewController).parentVC = self
        } else if let vc = segue.destination as? TeamViewController, segue.identifier == "unwindPitScoutingToTeam" {
            let navStack = self.navigationController?.viewControllers
            vc.previousViewController = navStack?[(navStack?.count)! - 3] as! ViewController?
            vc.teamNumber = (self.previousViewController as! TeamViewController).teamNumber
        } else if let vc = segue.destination as? MenuViewController, segue.identifier == "pitScoutingToMenu" {
            self.navigationStack = self.navigationController?.viewControllers
            vc.previousViewController = self
            vc.hasPrevious = true
        }
    }
    
    
}

extension Dictionary {
    static func += <K, V> (left: inout [K:V], right: inout [K:V]) {
        for (k, v) in right {
            left.updateValue(v, forKey: k)
        }
    }
}

class PitScoutingSectionView: UIView {
    
    @IBOutlet weak var displayButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    var parent: PitScoutingViewController?
    var state = false
    
    let keys = ["", "Takeoff", "Gear", "Fuel", "Fuel-High", "Fuel-Low", "Defense", "Auto"]
    
    override func awakeFromNib() {
        self.displayButton.layer.borderColor = UIColor.white.cgColor
        self.displayButton.layer.borderWidth = 1
        
        self.container.layer.borderColor = UIColor.white.cgColor
        self.container.layer.borderWidth = 1
        
        if(displayButton.tag == 0 || displayButton.tag == 8) {
            enable()
//            self.parent!.scrollView.layoutIfNeeded()
            self.displayButton.isEnabled = false
        }
    }
    
    @IBAction func displayButtonPressed(_ sender: UIButton) {
        if(state) {
            UIView.animate(withDuration: 0.25, animations: {
                self.displayButton.layer.backgroundColor = UIColor.clear.cgColor
                self.displayButton.setTitleColor(UIColor.white, for: .normal)
            })
            self.height.constant = 50
            state = false
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.displayButton.layer.backgroundColor = UIColor.white.cgColor
                self.displayButton.setTitleColor(UIColor(colorLiteralRed: 39/255, green: 117/255, blue: 46/255, alpha: 1), for: .normal)
            })
            self.height.constant = 50 + self.container.frame.height
            state = true
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.parent!.scrollView.layoutIfNeeded()
        })
    }
    
    func setEnabled(data: [String: String]) {
        for (i, key) in keys.enumerated() {
            if (data[key] == "true" && self.displayButton.tag == i) {
                enable()
                self.parent!.scrollView.layoutIfNeeded()
            }
        }
    }
    
    func enable() {
        self.displayButton.layer.backgroundColor = UIColor.white.cgColor
        self.displayButton.setTitleColor(UIColor(colorLiteralRed: 39/255, green: 117/255, blue: 46/255, alpha: 1), for: .normal)
        self.height.constant = 50 + self.container.frame.height
        state = true
        
    }
}
