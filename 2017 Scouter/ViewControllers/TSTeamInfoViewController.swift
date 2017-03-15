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

class TeamInfoViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    var teamNumber = 0
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var infoTable: InfoTable!
    @IBOutlet weak var scrollingView: UIView!
    @IBOutlet weak var pitScoutingButton: UIButton!
    
    var parentVC: TeamViewController?
    
    var client: DropboxClient?
    
    override func viewWillAppear(_ animated: Bool) {
        image.isUserInteractionEnabled = true;
        self.view.layer.backgroundColor = UIColor.clear.cgColor
        
        //Image stuff
        let fileManager = FileManager.default
        let directoryURL = FileManager().urls(for: .applicationSupportDirectory, in: .userDomainMask)[0] as URL
        let destURL = directoryURL.appendingPathComponent(Data.competition! + "/frc" + String(self.teamNumber))
        
        if(fileManager.contents(atPath: destURL.relativePath) != nil) {
            self.image.image = UIImage(data: fileManager.contents(atPath: destURL.relativePath)!)
        }
        
        //Info table view
        infoTable.delegate = self
        infoTable.dataSource = self
        infoTable.backgroundColor = UIColor.clear
        
        //Button Border
        pitScoutingButton.layer.borderWidth = 1
        pitScoutingButton.layer.borderColor = UIColor.white.cgColor
        if (Data.getPitScoutingFirebase(teamNumber: self.teamNumber) == nil) {
            pitScoutingButton.isEnabled = false
            pitScoutingButton.setTitleColor(UIColor(white: 1.0, alpha: 0.5), for: .normal)
            pitScoutingButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        } else {
            pitScoutingButton.isEnabled = true
            pitScoutingButton.setTitleColor(UIColor.white, for: .normal)
            pitScoutingButton.layer.borderColor = UIColor.white.cgColor
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
    
    @IBAction func pitScoutingPressed(_ sender: Any) {
        self.parentVC!.performSegue(withIdentifier: "teamToPitScouting", sender: self.teamNumber)
    }
    //Table stuff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let team = Data.getTeam(withNumber: self.teamNumber)!
        if (indexPath.row < (team.importantStats.count + 1) / 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImportantCell", for: indexPath) as! ImportantCell
            let key1 = Array(team.importantStats.keys)[indexPath.row * 2]
            let value1 = String(describing: team.importantStats[key1]!)
            cell.stat1.text = key1
            cell.value1.text = value1
            if !(indexPath.row * 2 + 1 == team.importantStats.count) {
                let key2 = Array(team.importantStats.keys)[indexPath.row * 2 + 1]
                let value2 = String(describing: team.importantStats[key2]!)
                cell.stat2.text = key2
                cell.value2.text = value2
            } else {
                cell.stat2.text = ""
                cell.value2.text = ""
            }
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
            let key = (Array(team.otherStats.keys).sorted { $0 < $1 })[indexPath.row - (team.importantStats.count + 1) / 2]
            let value = String(describing: team.otherStats[key]!)
            cell.textLabel?.text = key + ": " + value
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.numberOfLines=0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row < (Data.getTeam(withNumber: self.teamNumber)!.importantStats.count + 1) / 2) {
            return 300
        } else {
            print(indexPath.row)
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((Data.getTeam(withNumber: self.teamNumber)?.importantStats.count)! + 1)/2 + (Data.getTeam(withNumber: self.teamNumber)?.otherStats.count)!
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        if (indexPath.row < (Data.getTeam(withNumber: self.teamNumber)!.importantStats.count + 1) / 2) {
//            return 60
//        } else {
//            return UITableViewAutomaticDimension
//        }
//    }   
}

class InfoTable: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        get {
            self.layoutIfNeeded()
            return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
        }
    }
}

class ImportantCell: UITableViewCell {
    @IBOutlet weak var stat1: UILabel!
    @IBOutlet weak var stat2: UILabel!
    @IBOutlet weak var value1: UILabel!
    @IBOutlet weak var value2: UILabel!
}
