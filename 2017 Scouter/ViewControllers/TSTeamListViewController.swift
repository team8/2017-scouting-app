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
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var teamTable: UITableView!
    
    override func viewDidLoad() {
        teamTable.dataSource = self
        teamTable.delegate = self
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        print("ym")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Menu Button Image Sizing
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        teamTable.backgroundColor = UIColor.clear
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
        cell.teamNum = Data.teamList[indexPath.row]
        cell.rankingNumber.text = "#" + String(indexPath.row + 1)
        cell.teamNumber.text = String(Data.teamList[indexPath.row])
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TeamTableViewCell
        self.performSegue(withIdentifier: "teamListToTeam", sender: cell.teamNum)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "teamListToTeam") {
            let secondViewController = segue.destination as! TeamViewController
            let teamNumber = sender as! Int
            secondViewController.teamNumber = teamNumber
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.teamList.count
    }

    @IBAction func teamListUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
}
