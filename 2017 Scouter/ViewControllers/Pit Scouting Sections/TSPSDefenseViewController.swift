//
//  File.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PSDefenseViewController: PSSectionViewController, UITextViewDelegate {
    
    @IBOutlet var borderAreas: [UITextView]!
    
    @IBOutlet weak var notes: UITextView!
    
    override var tag: Int { get { return 6 } }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            return ["Defense": "false"]
        }
        return [
            "Defense": "true",
            "Defense-Notes": notes.text!
        ]
    }
    
    override func setData(data: [String : String]) {
        if (data["Defense"] == "false") {
            return
        }
        notes.text = data["Defense-Notes"]
    }
    
    override func setEnabled(_ state: Bool) {
        notes.isUserInteractionEnabled = state
    }
}
