//
//  File.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PSGearingViewController: PSSectionViewController, UITextViewDelegate {
    @IBOutlet var borderButtons: [UIButton]!
    @IBOutlet var borderAreas: [UITextView]!
    
    @IBOutlet weak var pilot: ButtonGroup!
    @IBOutlet weak var groundIntake: ButtonGroup!
    @IBOutlet weak var notes: UITextView!
    
    override var tag: Int { get { return 2 } }
    
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
            return ["Gear": "false"]
        }
        if (pilot.value == nil || groundIntake.value == nil) {
            return nil
        }
        return [
            "Gear": "true",
            "Gear-Pilot": pilot.value!,
            "Gear-Ground-Intake": groundIntake.value!,
            "Gear-Notes": notes.text
        ]
    }
    
    override func setData(data: [String : String]) {
        if (data["Gear"] == "false") {
            return
        }
        pilot.setButton(data["Gear-Pilot"]!)
        groundIntake.setButton(data["Gear-Ground-Intake"]!)
        notes.text = data["Gear-Notes"]
    }
    
    override func setEnabled(_ state: Bool) {
        pilot.setEnabled(state)
        groundIntake.setEnabled(state)
        notes.isUserInteractionEnabled = state
    }
}
