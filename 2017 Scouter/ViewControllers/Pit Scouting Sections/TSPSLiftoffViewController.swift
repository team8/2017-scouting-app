//
//  File.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PSLiftoffViewController: PSSectionViewController, UITextViewDelegate {
    @IBOutlet var borderButtons: [UIButton]!
    @IBOutlet var borderAreas: [UITextView]!
    
    @IBOutlet weak var climbSpeed: ButtonGroup!
    @IBOutlet weak var ownRope: ButtonGroup!
    @IBOutlet weak var climbTheirRope: ButtonGroup!
    @IBOutlet weak var climbOurRope: ButtonGroup!
    @IBOutlet weak var notes: UITextView!
    
    override var tag: Int { get { return 1 } }
    
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
        if(!self.parentView!.state) {
            return ["Takeoff": "false"]
        }
        if(climbSpeed.value == nil || ownRope.value == nil || climbTheirRope.value == nil || climbOurRope.value == nil) {
            return nil
        }
        return [
            "Takeoff": "true",
            "Takeoff-Speed": climbSpeed.value!,
            "Takeoff-Rope": ownRope.value!,
            "Takeoff-Climb-Their-Rope": climbTheirRope.value!,
            "Takeoff-Climb-Our-Rope": climbOurRope.value!,
            "Takeoff-Notes": notes.text
        ]
    }
    
    override func setData(data: [String : String]) {
        if (data["Takeoff"] == "false") {
            return
        }
        climbSpeed.setButton(data["Takeoff-Speed"]!)
        ownRope.setButton(data["Takeoff-Rope"]!)
        climbTheirRope.setButton(data["Takeoff-Climb-Their-Rope"]!)
        climbOurRope.setButton(data["Takeoff-Climb-Our-Rope"]!)
        notes.text = data["Takeoff-Notes"]
    }
    
    override func setEnabled(_ state: Bool) {
        climbSpeed.setEnabled(state)
        ownRope.setEnabled(state)
        climbTheirRope.setEnabled(state)
        climbOurRope.setEnabled(state)
        notes.isUserInteractionEnabled = state
    }
}
