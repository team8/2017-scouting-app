//
//  ViewController.swift
//  2017 Scouter
//
//  Created by Robert Selwyn on 10/28/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        //Gradient
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.frame
        let color1 = UIColor(colorLiteralRed: 34/255, green: 139/255, blue: 34/255, alpha: 1).cgColor
        let color2 = UIColor(colorLiteralRed: 17/255, green: 38/255, blue: 11/255, alpha: 1).cgColor
        gradient.colors = [color1, color2]
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //White status bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
}

