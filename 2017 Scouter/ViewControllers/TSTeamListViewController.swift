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
        teamTable.delegate = self
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        print("ym")
    }
    override func viewWillAppear(_ animated: Bool) {
        //Gradient
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.frame
        let color1 = UIColor(colorLiteralRed: 34/255, green: 139/255, blue: 34/255, alpha: 1).cgColor
        let color2 = UIColor(colorLiteralRed: 17/255, green: 38/255, blue: 11/255, alpha: 1).cgColor
        gradient.colors = [color1, color2]
        self.view.layer.insertSublayer(gradient, at: 0)
        
        teamTable.backgroundColor = UIColor.clear
    }
    //White status bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
        cell.rankingNumber.text = "#" + String(indexPath.row + 1)
        cell.teamNumber.text = Data.teamList[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.teamList.count
    }

    @IBAction func teamListUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
}
