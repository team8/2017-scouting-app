//
//  TSErrorReportViewController.swift
//  2017 Scouter
//
//  Created by Robert Selwyn on 12/19/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation
import UIKit

//UITextFieldDelegate is used for dismissing the keyboard when tapped return
class TSErrorViewController : ViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Name: UITextField!
    
    @IBOutlet weak var BigTextField: UITextView!
    
    @IBOutlet weak var SubmitButton: UIButton!
    
    
    override func viewDidLoad() {
        previousScreen = currentScreen
        currentScreen = "bug-report"
        
        SubmitButton.addTarget(self, action: #selector(TSErrorViewController.submit(_:)), for: .touchUpInside)
        
        //Setting the delegate to self so we can use the "textfieldShouldReturn" function
        Name.delegate = self
        
        //This runs when the user taps anywhere other than the textfield and textview
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        
    }
    //hides keyboard (only on textfield) when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("here")
        textField.resignFirstResponder()
        return true
    }
    
    //hides keyboard
    func dismissKeyboard(){
        view.endEditing(true);
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
        BigTextField.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 10, right: 10)
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
