//
//  File.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PSDriverExperienceViewController: PSSectionViewController, UITextViewDelegate {
    @IBOutlet var borderButtons: [UIButton]!
    @IBOutlet var borderAreas: [UITextView]!
    
    @IBOutlet weak var exp: ButtonGroup!
    @IBOutlet weak var practice: ButtonGroup!
    @IBOutlet weak var notes: UITextView!
    
    override var tag: Int { get { return 8 } }
    
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
        if (exp.value == nil || practice.value == nil) {
            return nil
        }
        return [
            "Driver-Exp": exp.value!,
            "Driver-Practice": practice.value!,
            "Driver-Notes": notes.text!
        ]
    }
    
    override func setData(data: [String : String]) {
        exp.setButton(data["Driver-Exp"]!)
        practice.setButton(data["Driver-Practice"]!)
        notes.text = data["Driver-Notes"]
    }
    
    override func setEnabled(_ state: Bool) {
        exp.setEnabled(state)
        practice.setEnabled(state)
        notes.isUserInteractionEnabled = state
    }
}
