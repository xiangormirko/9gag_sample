//
//  MemeViewController.swift
//  9gag_mock
//
//  Created by MIRKO on 5/25/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit



class MemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var resources = [Meme]()
    let threshold = 200.0 // threshold from bottom of tableView
    var isLoadingMore = false // flag
    var nextPaging : String = ""
    var contentType : String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resources.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let res = self.resources[indexPath.row]
        
        let cellIdentifier = "hotCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeTableCell
        
        // Set the title and image, retrieve image from cache or make request
        cell.titleLabel.text = res.caption
        
        let imageURL = NSURL(string: res.photoURL)
        cell.imageUrl = imageURL
        if let image = imageURL?.cachedImage {

            cell.memeImage.image = image
        } else {
            imageURL?.fetchImage { image in
                if cell.imageUrl == imageURL {
                    dispatch_async(dispatch_get_main_queue()) {
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
    
  
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // if content are about to terminate, make call for more data
        if (indexPath.row == resources.count - 5) && !isLoadingMore {
            isLoadingMore = true
            GAG.sharedInstance().taskForResource(contentType, last: nextPaging) { JSONResult, error in
                if let error = error {
                    print(error)
                } else {
                    var updateIndex: [NSIndexPath] = []
                    if let memes = JSONResult.valueForKey("data") as? [[String : AnyObject]] {
                        for meme in memes{
                            let testMeme = Meme(data: meme)
                            self.resources.append(testMeme)
                            let index = NSIndexPath(forRow: self.resources.count - 1 , inSection: 0)
                            updateIndex.append(index)

                        }
                      
                        // Update UI
                        dispatch_async(dispatch_get_main_queue()) {
                            self.isLoadingMore = false
                            self.tableView.reloadData()
                        }
                        
                    } else {
                        let error = NSError(domain: "JSON parsing error:\(JSONResult)", code: 0, userInfo: nil)
                        print(error)
                    }
                    
                    if let paging = JSONResult.valueForKey("paging") as? [String : AnyObject] {
                        let hotPaging = paging["next"] as! String
                        self.nextPaging = hotPaging
                    }
                }
            }
            

        }
    }
}
