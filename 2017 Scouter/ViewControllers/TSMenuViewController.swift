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

class MenuViewController: ViewController {
    
    
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
    }
    
    @IBAction func menuUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
}
