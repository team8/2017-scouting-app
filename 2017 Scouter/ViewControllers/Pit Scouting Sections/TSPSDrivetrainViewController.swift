//
//  File.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PSDrivetrainViewController: PSSectionViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var borderButtons: [UIButton]!
    @IBOutlet var borderFields: [UITextField]!
    @IBOutlet var borderAreas: [UITextView]!
    
    @IBOutlet weak var drivetrainTypeGroup: ButtonGroup!
    @IBOutlet weak var driveCIMs: ButtonGroup!
    
    @IBOutlet weak var drivetrainType: UITextField!
    @IBOutlet weak var driveSpeed: UITextField!
    
    @IBOutlet weak var additionalNotes: UITextView!
    
    override var tag: Int { get { return 0 } }
    
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
        self.drivetrainType.delegate = self
        self.drivetrainType.returnKeyType = .done
        self.driveSpeed.delegate = self
        self.driveSpeed.returnKeyType = .done
        self.additionalNotes.delegate = self
        self.additionalNotes.returnKeyType = .done
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
    
    override func getData() -> [String: String]? {
        if (drivetrainTypeGroup.value == nil || driveSpeed.text! == "" || driveCIMs.value == nil) {
            return nil
        }
        var dtType: String
        if (drivetrainTypeGroup.value! != "Other") {
            dtType = drivetrainTypeGroup.value!
        } else {
            dtType = drivetrainType.text!
        }
        return [
            "Dt-Type": dtType,
            "Dt-Speed": driveSpeed.text!,
            "Dt-Cims": driveCIMs.value!,
            "Dt-Notes": additionalNotes.text
        ]
    }
    
    override func setData(data: [String : String]) {
        if !(drivetrainTypeGroup.setButton(data["Dt-Type"]!)) {
            drivetrainTypeGroup.setButton("Other")
            drivetrainType.text = data["Dt-Type"]
        }
        driveSpeed.text = data["Dt-Speed"]
        driveCIMs.setButton(data["Dt-Cims"]!)
        additionalNotes.text = data["Dt-Notes"]
    }
    
    override func setEnabled(_ state: Bool) {
        drivetrainTypeGroup.setEnabled(state)
        driveCIMs.setEnabled(state)
        drivetrainType.isUserInteractionEnabled = state
        driveSpeed.isUserInteractionEnabled = state
        additionalNotes.isUserInteractionEnabled = state
    }
}
