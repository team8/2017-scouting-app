//
//  File.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PSBallStorageViewController: PSSectionViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet var borderButtons: [UIButton]!
    @IBOutlet var borderFields: [UITextField]!
    @IBOutlet var borderAreas: [UITextView]!
    
    @IBOutlet weak var intakeHopper: ButtonGroup!
    @IBOutlet weak var intakeGround: ButtonGroup!
    @IBOutlet weak var capacity: UITextField!
    @IBOutlet weak var notes: UITextView!
    
    override var tag: Int { get { return 3 } }
    
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
            return ["fuel": "false"]
        }
        if (intakeHopper.value == nil || intakeGround.value == nil || capacity.text! == "") {
            return nil
        }
        return [
            "fuel": "true",
            "fuel_intake_hopper": intakeHopper.value!,
            "fuel_intake_ground": intakeGround.value!,
            "fuel_capacity": capacity.text!,
            "fuel_notes": notes.text!
        ]
    }
}
