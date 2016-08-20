//
//  ViewController.swift
//  scouter
//
//  Created by Robert Selwyn on 8/19/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

