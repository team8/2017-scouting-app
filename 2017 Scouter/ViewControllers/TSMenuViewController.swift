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

class MenuViewController: UIViewController {
    
    
    @IBOutlet var menuButtons: [UIButton]!
    
    
    override func viewDidLoad() {

        
    }
    
    var client: DropboxClient?
    
    @IBOutlet weak var testImage: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        
        let fileManager = FileManager.default
        let directoryURL = FileManager().urls(for: .applicationSupportDirectory, in: .userDomainMask)[0] as URL
        let destURL = directoryURL.appendingPathComponent("myTestFile")
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return destURL
        }
        
        client = DropboxClient(accessToken: "uzaRy4m3BHAAAAAAAAAAFMyywnsKTZDeS5ONnUvnYNXW5Mzcw1CogAguXx03o8u3")
        client!.files.getThumbnail(path: "/Scouting/Robot Pictures 2017/test/frc8.png", format: Files.ThumbnailFormat.png, size: Files.ThumbnailSize.w1024h768, overwrite: true, destination: destination)
            .response { response, error in
                if let response = response {
                    print(response)
                    self.testImage.image = UIImage(data: fileManager.contents(atPath: destURL.relativePath)!)
                } else if let error = error {
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
        }
        
        if previousScreen != "none"{
            previousScreen = currentScreen
        }
        currentScreen = "menu"
        
        //Gradient
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.frame
        let color1 = UIColor(colorLiteralRed: 34/255, green: 139/255, blue: 34/255, alpha: 1).cgColor
        let color2 = UIColor(colorLiteralRed: 17/255, green: 38/255, blue: 11/255, alpha: 1).cgColor
        gradient.colors = [color1, color2]
        self.view.layer.insertSublayer(gradient, at: 0)
        
        
        //Borders
        for menuButton in menuButtons{
            //Borders
            menuButton.layer.borderWidth = 1
            menuButton.layer.borderColor = UIColor.white.cgColor
            
        }
        

    }
    
    
    //White status bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    

}
