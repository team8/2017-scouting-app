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
            return ["fuel_high": "false"]
        }
        if (vision.value == nil || capacity.text! == "" || accuracy.value == nil) {
            return nil
        }
        return [
            "fuel_high": "true",
            "fuel_high_vision": vision.value!,
            "fuel_high_in_key": String(describing: inKey.state),
            "fuel_high_out_key": String(describing: outKey.state),
            "fuel_high_capacity": capacity.text!,
            "fuel_high_accuracy": accuracy.value!,
            "fuel_high_notes": notes.text!
        ]
    }
}
