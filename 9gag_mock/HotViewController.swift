//
//  HotViewController.swift
//  9gag_mock
//
//  Created by MIRKO on 5/25/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit

class HotViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var resources = [Meme]()
    
    @IBOutlet weak var tableView: UITableView!
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeTableCell
        
        // Set the title and image
        cell.titleLabel.text = res.caption
        
        let imageURL = NSURL(string: res.photoURL)
        cell.imageUrl = imageURL
        if let image = imageURL?.cachedImage {
            print("got cached goodies for you")
            cell.memeImage.image = image
        } else {
            print("fetching image for you")
            imageURL?.fetchImage { image in
                if cell.imageUrl == imageURL {
                    print("image ready")
                    dispatch_async(dispatch_get_main_queue()) {
                        print("setting image in main")
                        cell.memeImage.image = image
                        tableView.reloadData()
                    }
                }
                
            }
        }

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}