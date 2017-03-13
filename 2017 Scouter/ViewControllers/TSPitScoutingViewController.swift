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
    
    var viewing: Bool?
    
    var pitScouting: PitScouting?
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveUploadButton: UIButton!
    
    var previousViewController: ViewController?
    
    @IBOutlet var sectionViews: [PitScoutingSectionView]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var sectionVCs = [PSSectionViewController]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for view in sectionViews {
            view.parent = self
        }
        self.viewing = false
    }
 
    @IBAction func editButtonPressed(_ sender: Any) {
        
    }
    @IBAction func saveUploadPressed(_ sender: Any) {
        if (self.viewing)! {
            
        } else {
            var data = [String: String]()
            for vc in sectionVCs {
                if (vc.getData() == nil) {
                    print("rip")
                    return
                }
                for (k, v) in vc.getData()! {
                    data.updateValue(v, forKey: k)
                }
            }
            print(data)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        //Send data to embedded view controllers
        if let vc = segue.destination as? PSSectionViewController {
            for view in sectionViews {
                if (view.displayButton.tag == vc.tag) {
                    vc.parentView = view
                }
            }
            self.sectionVCs.append(vc)
//            self.embeddedViewController = vc
//            (self.embeddedViewController?.viewControllers?[0] as! TeamInfoViewController).teamNumber = self.teamNumber
//            (self.embeddedViewController?.viewControllers?[1] as! TeamMatchesViewController).teamNumber = self.teamNumber
//            (self.embeddedViewController?.viewControllers?[1] as! TeamMatchesViewController).parentVC = self
        }
    }
    
    
}

extension Dictionary {
    static func += <K, V> (left: inout [K:V], right: inout [K:V]) {
        for (k, v) in right {
            left.updateValue(v, forKey: k)
        }
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
            
            self.height.constant = 50 + self.container.frame.height
            state = true
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.parent!.scrollView.layoutIfNeeded()
        })
    }
}
