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
            return ["Fuel": "false"]
        }
        if (intakeHopper.value == nil || intakeGround.value == nil || capacity.text! == "") {
            return nil
        }
        return [
            "Fuel": "true",
            "Fuel-Intake-Hopper": intakeHopper.value!,
            "Fuel-Intake-Ground": intakeGround.value!,
            "Fuel-Capacity": capacity.text!,
            "Fuel-Notes": notes.text!
        ]
    }
    
    override func setData(data: [String : String]) {
        if (data["Fuel"] == "false") {
            return
        }
        intakeHopper.setButton(data["Fuel-Intake-Hopper"]!)
        intakeGround.setButton(data["Fuel-Intake-Ground"]!)
        capacity.text = data["Fuel-Capacity"]
        notes.text = data["Fuel-Notes"]
    }
    
    override func setEnabled(_ state: Bool) {
        intakeHopper.setEnabled(state)
        intakeGround.setEnabled(state)
        capacity.isUserInteractionEnabled = state
        notes.isUserInteractionEnabled = state
    }
}
