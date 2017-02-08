//
//  TSTeamInfoViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 1/30/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDropbox

class TeamInfoViewController: ViewController {
    
    var teamNumber = 0
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var scrollingView: UIView!
    
    var client: DropboxClient?
    
    override func viewWillAppear(_ animated: Bool) {
        image.isUserInteractionEnabled = true;
        self.view.layer.backgroundColor = UIColor.clear.cgColor
        
        let fileManager = FileManager.default
        let directoryURL = FileManager().urls(for: .applicationSupportDirectory, in: .userDomainMask)[0] as URL
        let destURL = directoryURL.appendingPathComponent(Data.competition! + "/frc" + String(self.teamNumber))
        
        if(fileManager.contents(atPath: destURL.relativePath) != nil) {
            self.image.image = UIImage(data: fileManager.contents(atPath: destURL.relativePath)!)
        }
    }
    @IBAction func imageTapped(_ sender: Any) {
        self.addActivityIndicator()
        let fileManager = FileManager.default
        let directoryURL = FileManager().urls(for: .applicationSupportDirectory, in: .userDomainMask)[0] as URL
        do {
            try fileManager.createDirectory(atPath: directoryURL.appendingPathComponent(Data.competition!).relativePath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        let destURL = directoryURL.appendingPathComponent(Data.competition! + "/frc" + String(self.teamNumber))
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return destURL
        }
        
        client = DropboxClient(accessToken: "uzaRy4m3BHAAAAAAAAAAFMyywnsKTZDeS5ONnUvnYNXW5Mzcw1CogAguXx03o8u3")
        client!.files.getThumbnail(path: "/Scouting/Robot Pictures 2017/" + Data.competition! + "/frc" + String(self.teamNumber) + ".png", format: Files.ThumbnailFormat.png, size: Files.ThumbnailSize.w1024h768, overwrite: true, destination: destination)
            .response { response, error in
                self.removeActivityIndicator()
                if let response = response {
                    print(response)
                    self.image.image = UIImage(data: fileManager.contents(atPath: destURL.relativePath)!)
                } else if let error = error {
                    print(error.description)
                    if error.description.range(of:"not_found") != nil{
                        self.image.image = UIImage(named: "placeholder_unavailable.png")
                    }
                }
            }
            .progress { progressData in
                print(progressData)
        }

    }
    
    func addActivityIndicator() {
        print("add")
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 320, height: 226)
        activityIndicator.tag = 101
        activityIndicator.startAnimating()
        self.scrollingView.addSubview(activityIndicator)
        
    }
    
    func removeActivityIndicator() {
        
        print("remove")
        if let activityIndicator = self.view.viewWithTag(101) {
            activityIndicator.removeFromSuperview()
        }
    }
    
}
