//
//  TrendingViewController.swift
//  9gag_mock
//
//  Created by MIRKO on 5/25/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit

class TrendingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let resources = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resources.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let res = self.resources[indexPath.row]
        
        let cellIdentifier = "hotCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        // Set the title and image
        cell.textLabel!.text = String(res)
        
        
        return cell
    }
    

}
