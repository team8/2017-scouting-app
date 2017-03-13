//
//  TS.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PSSectionViewController: UIViewController {
    
    var tag: Int { get { return -1 } }
    var parentView: PitScoutingSectionView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    func getData() -> [String: String]? {
        return ["lol": "lol"]
    }
}
class ButtonGroup: UIStackView {
    
    @IBOutlet var buttons: [UIButton]!
    var value: String?
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            for button in self.buttons {
                button.layer.backgroundColor = UIColor.clear.cgColor
                button.setTitleColor(UIColor.white, for: .normal)
            }
            sender.layer.backgroundColor = UIColor.white.cgColor
            sender.setTitleColor(UIColor.clear, for: .normal)
        })
        self.value = sender.titleLabel?.text
    }
    
}
class ToggleButton: UIButton {
    var toggleState = false
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25, animations: {
            if (self.toggleState) {
                self.layer.backgroundColor = UIColor.clear.cgColor
                self.setTitleColor(UIColor.white, for: .normal)
                self.toggleState = false
            } else {
                self.layer.backgroundColor = UIColor.white.cgColor
                self.setTitleColor(UIColor.clear, for: .normal)
                self.toggleState = true
            }
        })
        self.sendActions(for: UIControlEvents.touchUpInside)
    }
}
