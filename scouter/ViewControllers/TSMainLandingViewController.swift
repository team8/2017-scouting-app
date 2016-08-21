//
//  ViewController.swift
//  scouter
//
//  Created by Robert Selwyn on 8/19/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import UIKit
import Device

class ViewController: UIViewController {

    @IBOutlet weak var SettingsTrailing: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the settings button.
        // On a small device, change the constant to 50
        if Device.isLargerThanScreenSize(.Screen4Inch) {
            SettingsTrailing.constant = 50
        }
        else {
            SettingsTrailing.constant = 100
        }
        
        // Set up the Settings Gesture Recognizer so that the Settings Icon can be clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ViewController.onSettingsClicked(_:)))
        SettingsImage.userInteractionEnabled = true
        SettingsImage.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onSettingsClicked(img: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("settings")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var StartButton: UIButton!
    
    @IBOutlet weak var SettingsImage: UIImageView!
    

    @IBAction func startClicked(sender: AnyObject) {
        print("Clicked")
    }
    
}

