//
//  _gag_mockUITests.swift
//  9gag_mockUITests
//
//  Created by MIRKO on 5/23/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import XCTest

class _gag_mockUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testTabs() {
        // test that tab buttons are correctly instantiated and thus exists
        let app = XCUIApplication()
        XCTAssert(app.buttons["TRENDING"].exists)
        XCTAssert(app.buttons["FRESH"].exists)
        XCTAssert(app.buttons["HOT"].exists)
    }
    
    func testViews() {
        // test that collectionview, scroll view, and tableview exist
        let app = XCUIApplication()
        
        XCTAssert(app.collectionViews.element.exists)
        XCTAssert(app.scrollViews.element.exists)
        XCTAssert(app.scrollViews.otherElements.tables.element.exists)

    }
    
    
}
