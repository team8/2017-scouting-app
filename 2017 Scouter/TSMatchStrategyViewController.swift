//
//  TSMatchStrategyViewController.swift
//  2017 Scouter
//
//  Created by Robert Selwyn on 3/28/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class MatchStrategyViewController : UIViewController {
    
    static var match : TBAMatch?
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var red: UITextView!
    
    @IBOutlet weak var blue: UITextView!
    
    override func viewDidLoad() {
        titleText.text = MatchStrategyViewController.match?.key.replacingOccurrences(of: "2017", with: "")
        red.isScrollEnabled = true
        blue.isScrollEnabled = true
        
        red.text = ""
        blue.text = ""
        
    }
    
}
