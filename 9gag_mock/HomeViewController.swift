//
//  HomeViewController.swift
//  9gag_mock
//
//  Created by MIRKO on 5/23/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    let sample_data = [1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var hotMemes = [Meme]()
    
    @IBOutlet weak var freshButton: UIButton!
    @IBOutlet weak var trendingButton: UIButton!
    @IBOutlet weak var hotButton: UIButton!
    @IBOutlet weak var activeLine: UIView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let hotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("hot") as! HotViewController
        
        hotVC.resources = hotMemes
        
        self.addChildViewController(hotVC)
        self.scrollView.addSubview(hotVC.view)
        hotVC.didMoveToParentViewController(self)
        
        let trendingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("trending") as! TrendingViewController
        
        var frame1 = trendingVC.view.frame
        frame1.origin.x = self.view.frame.size.width
        trendingVC.view.frame = frame1
        
        self.addChildViewController(trendingVC)
        self.scrollView.addSubview(trendingVC.view)
        trendingVC.didMoveToParentViewController(self)
        
        let freshVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("fresh") as! FreshViewController
        
        var frame2 = trendingVC.view.frame
        frame2.origin.x = self.view.frame.size.width * 2
        freshVC.view.frame = frame2
        
        self.addChildViewController(freshVC)
        self.scrollView.addSubview(freshVC.view)
        freshVC.didMoveToParentViewController(self)
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height)
        
        populateInitialData(hotVC)

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sample_data).count
    }
    
    @IBAction func didTapButton(sender: UIButton) {
        updateConstraintsForActiveLineView(activeLine, underButton:sender)
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func updateConstraintsForActiveLineView(activeLine: UIView, underButton: UIButton) {
        leadingConstraint.constant = underButton.frame.origin.x
    }
    
    
    func populateInitialData(hotVC: HotViewController) {
        GAG.sharedInstance().taskForResource("hot", last: "") { JSONResult, error in
            if let error = error {
                print(error)
            } else {
                //                print(JSONResult)
                if let memes = JSONResult.valueForKey("data") as? [[String : AnyObject]] {
                    for meme in memes{
                        let testMeme = Meme(data: meme)
                        self.hotMemes.append(testMeme)
                    }
                    hotVC.resources = self.hotMemes
                    dispatch_async(dispatch_get_main_queue()) {
                        hotVC.tableView.reloadData()
                    }
                    
                    
                } else {
                    let error = NSError(domain: "JSON parsing error:\(JSONResult)", code: 0, userInfo: nil)
                    print(error)
                }
                
                if let paging = JSONResult.valueForKey("paging") as? [String : AnyObject] {
                    let hotPaging = paging["next"] as! String
                    hotVC.nextPaging = hotPaging
                }
                
            }
        }
    }
    
    

}

