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
    
    @IBOutlet weak var menuButton: UIButton!
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TSErrorViewController.dismissKeyboard))
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
        super.viewWillAppear(animated)
        
        //Menu Button Image Sizing
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        //Submit Button Borders
        SubmitButton.layer.borderColor = UIColor.white.cgColor
        SubmitButton.layer.borderWidth = 1.0
        
        //TextView Padding
        BigTextField.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 10, right: 10)
        BigTextField.layer.cornerRadius = 5.0
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
