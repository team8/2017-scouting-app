//
//  TSSettingsViewController.swift
//  scouter
//
//  Created by Robert Selwyn on 8/19/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import UIKit
import SCLAlertView

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do anything here
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ServerTest(sender: AnyObject) {
            ServerInterfacer.testConnection(callBackToTest)
    }
    
    func callBackToTest(success: Bool) -> Void {
        if success {
            let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showSuccess("Connected", subTitle: "You are connected to the scouting server.")
        }
        else {
            let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showError("Not Connected", subTitle: "You are not connected to the scouting server.")

        }
    }
    
}