//
//  File.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PSLowGoalViewController: PSSectionViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var borderFields: [UITextField]!
    @IBOutlet var borderAreas: [UITextView]!
    
    @IBOutlet weak var capacity: UITextField!
    @IBOutlet weak var notes: UITextView!
    
    override var tag: Int { get { return 5 } }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            return ["Fuel-Low": "false"]
        }
        if (capacity.text! == "") {
            return nil
        }
        return [
            "Fuel-Low": "true",
            "Fuel-Low-Capacity": capacity.text!,
            "Fuel-Low-Notes": notes.text!
        ]
    }
    
    override func setData(data: [String : String]) {
        if (data["Fuel-Low"] == "false") {
            return
        }
        capacity.text = data["Fuel-Low-Capacity"]
        notes.text = data["Fuel-Low-Notes"]
    }
    
    override func setEnabled(_ state: Bool) {
        capacity.isUserInteractionEnabled = state
        notes.isUserInteractionEnabled = state
    }
}
