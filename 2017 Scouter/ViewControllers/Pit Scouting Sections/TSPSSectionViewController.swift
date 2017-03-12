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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layer.backgroundColor = UIColor.clear.cgColor
    }
}
class ButtonGroup: UIStackView {
    
    @IBOutlet var buttons: [UIButton]!
    
    
    
}
