//
//  TSPitScoutingViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PitScoutingViewController: ViewController {
    
    var previousViewController: ViewController?
    
    @IBOutlet var sectionViews: [PitScoutingSectionView]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for view in sectionViews {
            view.parent = self
        }
    }
 
    @IBAction func editButtonPressed(_ sender: Any) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        //Send data to embedded view controllers
//        if let vc = segue.destination as? PSSectionViewController, segue.identifier == "drivetrainEmbed" {
//            self.drivetrainView.child = vc
////            self.embeddedViewController = vc
////            (self.embeddedViewController?.viewControllers?[0] as! TeamInfoViewController).teamNumber = self.teamNumber
////            (self.embeddedViewController?.viewControllers?[1] as! TeamMatchesViewController).teamNumber = self.teamNumber
////            (self.embeddedViewController?.viewControllers?[1] as! TeamMatchesViewController).parentVC = self
//        }
    }
}

class PitScoutingSectionView: UIView {
    
    @IBOutlet weak var displayButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    var parent: PitScoutingViewController?
    var state = false
    
    override func awakeFromNib() {
        self.displayButton.layer.borderColor = UIColor.white.cgColor
        self.displayButton.layer.borderWidth = 1
        
        self.container.layer.borderColor = UIColor.white.cgColor
        self.container.layer.borderWidth = 1
    }
    
    @IBAction func displayButtonPressed(_ sender: UIButton) {
        if(state) {
            self.height.constant = 50
            state = false
        } else {
            
            self.height.constant = 55 + self.container.frame.height
            state = true
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.parent!.scrollView.layoutIfNeeded()
        })
    }
}
