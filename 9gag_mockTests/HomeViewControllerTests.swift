//
//  HomeViewControllerTests.swift
//  9gag_mock
//
//  Created by MIRKO on 5/31/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import UIKit
import XCTest
@testable import _gag_mock

class HomeViewControllerTests: XCTestCase {
    
    var vc: HomeViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("homeController") as! HomeViewController
        vc.viewDidLoad()
        let _ = vc.view
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDataPopulation() {
        // test that data is correctly populated into the view and table
        
        let asyncExpectation = expectationWithDescription("data population")
        let hotVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("memeController") as! MemeViewController
        
        let _ = hotVC.view
        
        XCTAssert(vc.hotMemes.count == 0)
        XCTAssertNotNil(vc.trendingMemes)
        XCTAssertNotNil(vc.freshMemes)
        
        GAG.sharedInstance().taskForResource("hot", last: "") { JSONResult, error in
            XCTAssertNil(error, "error should be nil")
            XCTAssertNotNil(JSONResult, "JSON should be returned")

            
            if let error = error {
                print(error)
            } else {
                //                print(JSONResult)
                if let memes = JSONResult.valueForKey("data") as? [[String : AnyObject]] {
                    for meme in memes{
                        let testMeme = Meme(data: meme)
                        self.vc.hotMemes.append(testMeme)
                    }
                    hotVC.resources = self.vc.hotMemes
                    XCTAssert(hotVC.resources.count > 1)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        hotVC.tableView.reloadData()
                        self.vc.collectionView.reloadData()
                        XCTAssert(hotVC.tableView.numberOfSections > 0, "rows should be greated than 1")
                        asyncExpectation.fulfill()
                    }
                    
                    
                } else {
                    let error = NSError(domain: "JSON parsing error:\(JSONResult)", code: 0, userInfo: nil)
                    print(error)
                }
                
                if let paging = JSONResult.valueForKey("paging") as? [String : AnyObject] {
                    let hotPaging = paging["next"] as! String
                    hotVC.nextPaging = hotPaging
                    XCTAssert(hotVC.nextPaging == hotPaging)
                }
                
            }
        }
        waitForExpectationsWithTimeout(20) { error in
            XCTAssertNil(error, "Wait exceeded, something went wrong")

        }
        
    }
    
    func testMemeCreation() {
        // Test that the Meme model works and init method works
        
        GAG.sharedInstance().taskForResource("trending", last: "") { JSONResult, error in
            XCTAssertNil(error, "error should be nil")
            if let memes = JSONResult.valueForKey("data") as? [[String : AnyObject]] {
                for meme in memes{
                    let testMeme = Meme(data: meme)
                    self.vc.hotMemes.append(testMeme)
                    XCTAssertNotNil(testMeme.caption, "caption should not be nil")
                    XCTAssertNotNil(testMeme.id, "id should not be nil")
                    XCTAssertNotNil(testMeme.photoURL, "image url should not be nil")
                }
                
            }
            
        }
    }

}
