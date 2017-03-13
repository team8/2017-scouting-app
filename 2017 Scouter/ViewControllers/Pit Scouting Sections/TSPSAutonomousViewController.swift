//
//  File.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PSAutonomousViewController: PSSectionViewController, UITextViewDelegate {
    @IBOutlet var borderButtons: [UIButton]!
    @IBOutlet var borderAreas: [UITextView]!
    
    @IBOutlet weak var baseline: ToggleButton!
    @IBOutlet weak var gear: ToggleButton!
    @IBOutlet weak var fuelHigh: ToggleButton!
    @IBOutlet weak var fuelLow: ToggleButton!
    @IBOutlet weak var notes: UITextView!
    
    override var tag: Int { get { return 7 } }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for button in self.borderButtons {
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 1
        }
        for area in borderAreas {
            area.layer.borderColor = UIColor.white.cgColor
            area.layer.borderWidth = 1
        }
        self.notes.delegate = self
        self.notes.returnKeyType = .done
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    override func getData() -> [String : String]? {
        if (!self.parentView!.state) {
            return ["auto": "false"]
        }
        return [
            "auto": "true",
            "auto_baseline": String(baseline.toggleState),
            "auto_gear": String(gear.toggleState),
            "auto_fuel_high": String(fuelHigh.toggleState),
            "auto_fuel_low": String(fuelLow.toggleState),
            "auto_notes": notes.text!
        ]
    }
}
