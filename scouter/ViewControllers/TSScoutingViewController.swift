//
//  TSScoutingViewController.swift
//  scouter
//
//  Created by Robert Selwyn on 8/20/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import UIKit

class ScoutViewController: UIViewController {
    
    var myLabel = UILabel()
    var matches = [TBAMatch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(myLabel)
        self.myLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.myLabel, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 0.5, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.myLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.myLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    
}