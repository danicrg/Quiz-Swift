//
//  TipTableViewController.swift
//  Quiz
//
//  Created by Daniel Carlander on 17/11/2018.
//  Copyright © 2018 Daniel Carlander. All rights reserved.
//

import UIKit

class TipTableViewController: UITableViewController {
    
    var tipData: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
 }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tip cell", for: indexPath)
        let tip = tipData[indexPath.row]
        cell.textLabel?.text = tip

        return cell
    }

}
