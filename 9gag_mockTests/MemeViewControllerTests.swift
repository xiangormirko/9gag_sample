//
//  MemeViewControllerTests.swift
//  9gag_mock
//
//  Created by MIRKO on 5/31/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import XCTest
@testable import _gag_mock

class MemeViewControllerTests: XCTestCase {
    
    var vc: MemeViewController!

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("memeController") as! MemeViewController
        vc.viewDidLoad()
        let _ = vc.view
        
        

            
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImageCache() {
        // Test that image cache is correctly set
        
        let asyncExpectation = expectationWithDescription("fetch data")

        GAG.sharedInstance().taskForResource("hot", last: "") {JSONResult, error in
            XCTAssertNil(error, "error should be nil")
            XCTAssertNotNil(JSONResult, "JSON should be returned")
            
            
            if let error = error {
                print(error)
            } else {
                //                print(JSONResult)
                if let memes = JSONResult.valueForKey("data") as? [[String : AnyObject]] {
                    for meme in memes{
                        let testMeme = Meme(data: meme)
                        self.vc.resources.append(testMeme)
                    }
                    XCTAssert(self.vc.resources.count > 1)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.vc.tableView.reloadData()
                        XCTAssert(self.vc.tableView.numberOfRowsInSection(0) > 1, "rows should be greated than 1")
                        let cells = self.vc.tableView.indexPathsForVisibleRows
                        let cell = self.vc.tableView.cellForRowAtIndexPath(cells![0]) as! MemeTableCell
                        print(cell.imageUrl)
                        
                        XCTAssertNotNil(cell.imageUrl)
                        XCTAssertNotNil(cell.imageUrl.cachedImage, "image should be chached")
                        asyncExpectation.fulfill()
                        
                        
                    }
                    
                    
                } else {
                    let error = NSError(domain: "JSON parsing error:\(JSONResult)", code: 0, userInfo: nil)
                    print(error)
                }
                
                if let paging = JSONResult.valueForKey("paging") as? [String : AnyObject] {
                    let hotPaging = paging["next"] as! String
                    self.vc.nextPaging = hotPaging
                    XCTAssert(self.vc.nextPaging == hotPaging)
                }
                
            }
        }
        waitForExpectationsWithTimeout(10) { error in
            XCTAssertNil(error, "Wait exceeded, something went wrong")
            
        }
        
    }
    
}
