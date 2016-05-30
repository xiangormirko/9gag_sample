//
//  HomeViewController.swift
//  9gag_mock
//
//  Created by MIRKO on 5/23/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!

    var hotMemes = [Meme]()
    var trendingMemes = [Meme]()
    var freshMemes = [Meme]()
    var frame = CGFloat()
    
    @IBOutlet weak var freshButton: UIButton!
    @IBOutlet weak var trendingButton: UIButton!
    @IBOutlet weak var hotButton: UIButton!
    @IBOutlet weak var activeLine: UIView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        frame = self.view.frame.size.width
        
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Do any additional setup after loading the view, typically from a nib.
        
        let hotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("memeController") as! MemeViewController
        hotVC.contentType = "hot"
        hotVC.resources = hotMemes
        
        self.addChildViewController(hotVC)
        self.scrollView.addSubview(hotVC.view)
        hotVC.didMoveToParentViewController(self)
        
        let trendingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("memeController") as! MemeViewController
        trendingVC.contentType = "trending"
        var frame1 = trendingVC.view.frame
        frame1.origin.x = frame
        trendingVC.view.frame = frame1
        
        self.addChildViewController(trendingVC)
        self.scrollView.addSubview(trendingVC.view)
        trendingVC.didMoveToParentViewController(self)
        
        let freshVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("memeController") as! MemeViewController
        freshVC.contentType = "fresh"
        var frame2 = trendingVC.view.frame
        frame2.origin.x = frame * 2
        freshVC.view.frame = frame2
        
        self.addChildViewController(freshVC)
        self.scrollView.addSubview(freshVC.view)
        freshVC.didMoveToParentViewController(self)
        
        self.scrollView.contentSize = CGSizeMake(frame * 3, self.view.frame.size.height)
        
        populateInitialData(hotVC, trendingVC: trendingVC, freshVC: freshVC)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func didTapButton(sender: UIButton) {
        updateConstraintsForActiveLineView(activeLine, underButton:sender)
        
        let pageWidth = CGRectGetWidth(self.scrollView.frame)
        let frameHeight = CGRectGetHeight(self.scrollView.frame)

        
        switch sender.currentTitle! {
        case "HOT":
            self.scrollView.scrollRectToVisible(CGRectMake(0, 0, pageWidth, frameHeight), animated: true)
        case "TRENDING":
            self.scrollView.scrollRectToVisible(CGRectMake(frame, 0, pageWidth, frameHeight), animated: true)
        case "FRESH":
            self.scrollView.scrollRectToVisible(CGRectMake(frame * 2, 0, pageWidth, frameHeight), animated: true)
        default:
            print("default")
        }
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    func updateConstraintsForActiveLineView(activeLine: UIView, underButton: UIButton) {
        leadingConstraint.constant = underButton.frame.origin.x
    }
    
    
    func populateInitialData(hotVC: MemeViewController, trendingVC: MemeViewController, freshVC: MemeViewController) {
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
                        self.collectionView.reloadData()
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
        
        GAG.sharedInstance().taskForResource("trending", last: "") { JSONResult, error in
            if let error = error {
                print(error)
            } else {
                //                print(JSONResult)
                if let memes = JSONResult.valueForKey("data") as? [[String : AnyObject]] {
                    for meme in memes{
                        let testMeme = Meme(data: meme)
                        self.trendingMemes.append(testMeme)
                    }
                    trendingVC.resources = self.trendingMemes
                    dispatch_async(dispatch_get_main_queue()) {
                        trendingVC.tableView.reloadData()
                    }
                    
                    
                } else {
                    let error = NSError(domain: "JSON parsing error:\(JSONResult)", code: 0, userInfo: nil)
                    print(error)
                }
                
                if let paging = JSONResult.valueForKey("paging") as? [String : AnyObject] {
                    let trendingPaging = paging["next"] as! String
                    hotVC.nextPaging = trendingPaging
                }
                
            }
        }
        
        GAG.sharedInstance().taskForResource("fresh", last: "") { JSONResult, error in
            if let error = error {
                print(error)
            } else {
                //                print(JSONResult)
                if let memes = JSONResult.valueForKey("data") as? [[String : AnyObject]] {
                    for meme in memes{
                        let testMeme = Meme(data: meme)
                        self.freshMemes.append(testMeme)
                    }
                    freshVC.resources = self.freshMemes
                    dispatch_async(dispatch_get_main_queue()) {
                        freshVC.tableView.reloadData()
                    }
                    
                    
                } else {
                    let error = NSError(domain: "JSON parsing error:\(JSONResult)", code: 0, userInfo: nil)
                    print(error)
                }
                
                if let paging = JSONResult.valueForKey("paging") as? [String : AnyObject] {
                    let freshPaging = paging["next"] as! String
                    freshVC.nextPaging = freshPaging
                }
                
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotMemes.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let res = self.hotMemes[indexPath.row]
        
        cell.memeCaption.text = res.caption
        let imageURL = NSURL(string: res.photoURL)
        cell.imageUrl = imageURL
        if let image = imageURL?.cachedImage {
            //            print("got cached goodies for you")
            cell.memeImage.image = image
        } else {
            print("fetching image for you")
            imageURL?.fetchImage { image in
                if cell.imageUrl == imageURL {
                    print("image ready")
                    dispatch_async(dispatch_get_main_queue()) {
                        print("setting image in main")
                        cell.memeImage.image = image
                        collectionView.reloadData()
                    }
                }
                
            }
        }

        
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    

}

