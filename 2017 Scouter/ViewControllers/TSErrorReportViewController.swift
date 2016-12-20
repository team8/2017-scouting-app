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
    override func viewWillAppear(_ animated: Bool) {
        //Gradient
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.frame
        let color1 = UIColor(colorLiteralRed: 34/255, green: 139/255, blue: 34/255, alpha: 1).cgColor
        let color2 = UIColor(colorLiteralRed: 17/255, green: 38/255, blue: 11/255, alpha: 1).cgColor
        gradient.colors = [color1, color2] //Or any colors
        self.view.layer.insertSublayer(gradient, at: 0)
        
        //Submit Button Borders
        SubmitButton.layer.borderColor = UIColor.white.cgColor
        SubmitButton.layer.borderWidth = 1.0
        
        //TextView Padding
        BigTextField.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        BigTextField.layer.cornerRadius = 5.0
    }
    
    //White status bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
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
