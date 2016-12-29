//
//  ViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 12/5/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation
import UIKit


var previousScreen = "none"
var currentScreen = "menu"

class MenuViewController: UIViewController {
    
    
    @IBOutlet var menuButtons: [UIButton]!
    
    
    override func viewDidLoad() {

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if previousScreen != "none"{
            previousScreen = currentScreen
        }
        currentScreen = "menu"
        
        //Gradient
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.frame
        let color1 = UIColor(colorLiteralRed: 34/255, green: 139/255, blue: 34/255, alpha: 1).cgColor
        let color2 = UIColor(colorLiteralRed: 17/255, green: 38/255, blue: 11/255, alpha: 1).cgColor
        gradient.colors = [color1, color2]
        self.view.layer.insertSublayer(gradient, at: 0)
        
        
        //Borders
        for menuButton in menuButtons{
            //Borders
            menuButton.layer.borderWidth = 1
            menuButton.layer.borderColor = UIColor.white.cgColor
            
        }
        

    }
    
    
    //White status bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    

}
