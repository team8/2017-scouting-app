//
//  TSMatchListViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 12/6/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation
import UIKit

class MatchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //    @IBOutlet weak var myButton : UIButton!
    //    @IBOutlet weak var myTextField : UITextField!
    //
    //    @IBAction func myButtonAction(sender: id)
    
    @IBOutlet weak var matchTable: UITableView!
    
    override func viewDidLoad() {
        matchTable.dataSource = self
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        print("ym")
        ServerInterfacer.getMatches(ServerInterfacer.handleMatchJSON, key: "2016cacc")
        self.matchTable.reloadData()
    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath)
        cell.textLabel?.text = Data.matchList[indexPath.row].getKeyAsDisplayable()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.matchList.count
    }
    
    @IBAction func teamListUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
}
