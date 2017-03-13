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
            "driver_exp": exp.value!,
            "driver_practice": practice.value!,
            "driver_notes": notes.text!
        ]
    }
}
