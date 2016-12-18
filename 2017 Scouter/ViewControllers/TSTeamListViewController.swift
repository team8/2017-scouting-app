//
//  ViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 12/5/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation
import UIKit

class TeamListViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
//    @IBOutlet weak var myButton : UIButton!
//    @IBOutlet weak var myTextField : UITextField!
//    
//    @IBAction func myButtonAction(sender: id)
    
    @IBOutlet weak var teamTable: UITableView!
    
    override func viewDidLoad() {
        teamTable.dataSource = self
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        print("ym")
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath)
        cell.textLabel?.text = Data.teamList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.teamList.count
    }
    
    @IBAction func teamListUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
}
