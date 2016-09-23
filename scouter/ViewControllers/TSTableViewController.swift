//
//  TSTableViewController.swift
//  scouter
//
//  Created by Robert Selwyn on 9/9/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import Foundation
import UIKit

class MatchTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.matchData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchCell", forIndexPath: indexPath)
        cell.textLabel?.text = Globals.matchData[indexPath.row].getKeyAsDisplayable()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let scoutingView = ScoutViewController()
        scoutingView.pointer = indexPath.row
        self.presentViewController(scoutingView, animated: true, completion: nil)
    
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

    }
}