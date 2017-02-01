//
//  ViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 12/5/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDropbox


var previousScreen = "none"
var currentScreen = "menu"

class MenuViewController: ViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var compTextField: UITextField!
    let compList = ["Ventura 2017", "SVR 2017", "Champs 2017"]
    let compIDs = ["2017cave", "2017casj", "2017cmptx"]
    let pickerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
    let doneButton = UIButton(frame: CGRect(x: 220, y: 0, width: 100, height: 50))
    let picker = UIPickerView(frame: CGRect(x: 0, y: 50, width: 320, height: 150))
    
    @IBOutlet var menuButtons: [UIButton]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if previousScreen != "none"{
            previousScreen = currentScreen
        }
        currentScreen = "menu"
    
        //Borders
        for menuButton in menuButtons{
            //Borders
            menuButton.layer.borderWidth = 1
            menuButton.layer.borderColor = UIColor.white.cgColor
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compTextField.delegate = self
        self.compTextField.backgroundColor = UIColor.clear
        self.compTextField.tintColor = UIColor.clear
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        picker.delegate = self
        picker.backgroundColor = UIColor.lightGray
        pickerView.backgroundColor = UIColor.white
        pickerView.addSubview(doneButton)
        pickerView.addSubview(picker)
        
//        let doneTrailingConstraint = NSLayoutConstraint(item: doneButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: pickerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
//        let doneTopConstraint = NSLayoutConstraint(item: doneButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: pickerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
//        
//        NSLayoutConstraint.activate([doneTrailingConstraint, doneTopConstraint])
        
        compTextField.inputView = pickerView
        
    }
    
    func pickerSelect(index: Int) {
        compTextField.text = compList[index]
        Data.competition = compIDs[index]
    }
    
    func donePressed(sender: UIButton!) {
        pickerSelect(index: self.picker.selectedRow(inComponent: 0))
        self.compTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return compList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return compList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelect(index: row)
    }
    
    @IBAction func menuUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
}
