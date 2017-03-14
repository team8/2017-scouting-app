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
            return ["Auto": "false"]
        }
        return [
            "Auto": "true",
            "Auto-Baseline": String(baseline.toggleState),
            "Auto-Gear": String(gear.toggleState),
            "Auto-Fuel-High": String(fuelHigh.toggleState),
            "Auto-Fuel-Low": String(fuelLow.toggleState),
            "Auto-Notes": notes.text!
        ]
    }
    
    override func setData(data: [String : String]) {
        if (data["Auto"]! == "false") {
            return
        }
        baseline.setToggle(data["Auto-Baseline"]!)
        gear.setToggle(data["Auto-Gear"]!)
        fuelHigh.setToggle(data["Auto-Fuel-High"]!)
        fuelLow.setToggle(data["Auto-Fuel-Low"]!)
        notes.text = data["Auto-Notes"]!
    }
    
    override func setEnabled(_ state: Bool) {
        baseline.isEnabled = state
        gear.isEnabled = state
        fuelHigh.isEnabled = state
        fuelLow.isEnabled = state
        notes.isUserInteractionEnabled = state
    }
}
