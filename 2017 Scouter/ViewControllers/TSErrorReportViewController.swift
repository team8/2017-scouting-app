//
//  TSErrorReportViewController.swift
//  2017 Scouter
//
//  Created by Robert Selwyn on 12/19/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation
import UIKit

class TSErrorViewController : ViewController {
    
    @IBOutlet weak var Name: UITextField!
    
    @IBOutlet weak var BigTextField: UITextView!
    
    @IBOutlet weak var SubmitButton: UIButton!
    
    
    override func viewDidLoad() {
        SubmitButton.addTarget(self, action: #selector(TSErrorViewController.submit(_:)), for: .touchUpInside)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        let messageContent = "FROM: " + Name.text! + ". MESSAGE: " + BigTextField.text
        print(messageContent)
        ServerInterfacer.sendBug(data: messageContent, callback: receivedResult)
        
    }
    
    func receivedResult(_ success : Bool) -> Void {
        print(success)
    }
}
