//
//  File.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PSHighGoalViewController: PSSectionViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet var borderButtons: [UIButton]!
    @IBOutlet var borderFields: [UITextField]!
    @IBOutlet var borderAreas: [UITextView]!
    
    @IBOutlet weak var vision: ButtonGroup!
    @IBOutlet weak var inKey: ToggleButton!
    @IBOutlet weak var outKey: ToggleButton!
    @IBOutlet weak var capacity: UITextField!
    @IBOutlet weak var accuracy: ButtonGroup!
    @IBOutlet weak var notes: UITextView!
    
    override var tag: Int { get { return 4 } }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for button in self.borderButtons {
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 1
        }
        for field in self.borderFields {
            field.layer.borderColor = UIColor.white.cgColor
            field.layer.borderWidth = 1
        }
        for area in borderAreas {
            area.layer.borderColor = UIColor.white.cgColor
            area.layer.borderWidth = 1
        }
        self.capacity.delegate = self
        self.capacity.returnKeyType = .done
        self.notes.delegate = self
        self.notes.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    override func getData() -> [String : String]? {
        if (!self.parentView!.state) {
            return ["Fuel-High": "false"]
        }
        if (vision.value == nil || capacity.text! == "" || accuracy.value == nil) {
            return nil
        }
        return [
            "Fuel-High": "true",
            "Fuel-High-Vision": vision.value!,
            "Fuel-High-In-Key": String(describing: inKey.toggleState),
            "Fuel-High-Out-Key": String(describing: outKey.toggleState),
            "Fuel-High-Capacity": capacity.text!,
            "Fuel-High-Accuracy": accuracy.value!,
            "Fuel-High-Notes": notes.text!
        ]
    }
    
    override func setData(data: [String : String]) {
        if (data["Fuel-High"] == "false") {
            return
        }
        vision.setButton(data["Fuel-High-Vision"]!)
        inKey.setToggle(data["Fuel-High-In-Key"]!)
        outKey.setToggle(data["Fuel-High-Out-Key"]!)
        capacity.text = data["Fuel-High-Capacity"]
        accuracy.setButton(data["Fuel-High-Accuracy"]!)
        notes.text = data["Fuel-High-Notes"]
    }
    
    override func setEnabled(_ state: Bool) {
        vision.setEnabled(state)
        inKey.isEnabled = state
        outKey.isEnabled = state
        capacity.isUserInteractionEnabled = state
        accuracy.setEnabled(state)
        notes.isUserInteractionEnabled = state
    }
}
