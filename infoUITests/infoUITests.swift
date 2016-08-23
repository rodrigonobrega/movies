//
//  infoUITests.swift
//  infoUITests
//
//  Created by Rodrigo Nóbrega on 8/19/16.
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import XCTest

class infoUITests: XCTestCase {
    
    let app     = XCUIApplication()
    let device  = XCUIDevice.sharedDevice()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        device.orientation = .Portrait
        super.tearDown()
    }
    
    func testTableNotNil() {
        let collectionViewsQuery = app.collectionViews
        XCTAssertNotNil(collectionViewsQuery.childrenMatchingType(.Cell), "Cell should not be nil");
    }
    
    func testInfiniteScroll() {
        
        for _ in 0...10 {
            app.collectionViews.element.swipeUp()
        }
        XCTAssertEqual(app.navigationBars.element.identifier, "Movies")
    }
    
    func testChangeFilter() {
        UIView.setAnimationsEnabled(false)
        
        
        device.orientation = .Portrait
        let buttonBestRated = app.collectionViews.buttons["Top Rated"]
        let buttonPopularity = app.collectionViews.buttons["Popularity"]
        let btnBest = buttonBestRated.coordinateWithNormalizedOffset(CGVectorMake(0.5, 0.5))
        let btnPop = buttonPopularity.coordinateWithNormalizedOffset(CGVectorMake(0.5, 0.5))
        
        btnBest.tap()
        sleep(1)
        btnPop.tap()
        sleep(1)
        btnBest.tap()
        sleep(1)
        btnPop.tap()
        sleep(1)
        
    }
    
    func testRotate() {
        device.orientation = .Portrait
        device.orientation = .LandscapeLeft
        device.orientation = .Portrait
        device.orientation = .LandscapeRight
        device.orientation = .Portrait
        device.orientation = .LandscapeLeft
        device.orientation = .LandscapeRight
    }
    
    func testSelectItens() {
        
        let collectionViewsQuery = app.collectionViews
        
        XCTAssertNotNil(collectionViewsQuery.childrenMatchingType(.Cell), "Cell should not be nil");
        collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(0).otherElements.childrenMatchingType(.Image).element.coordinateWithNormalizedOffset(CGVector(dx: 0.5, dy: 0.5)).tap()
        let moviesButton = self.app.navigationBars.matchingIdentifier("Movie Detail").buttons["Movies"]
        sleep(1)
        moviesButton.tap()
        
        sleep(1)
        
        XCTAssertNotNil(collectionViewsQuery.childrenMatchingType(.Cell), "Cell should not be nil");
        collectionViewsQuery.childrenMatchingType(.Cell).elementBoundByIndex(1).otherElements.childrenMatchingType(.Image).element.coordinateWithNormalizedOffset(CGVector(dx: 0.5, dy: 0.5)).tap()
        sleep(1)
        moviesButton.tap()
        sleep(1)
        
        XCTAssertEqual(app.navigationBars.element.identifier, "Movies")
    }
    
    func testVoteUpdate() {
        app.collectionViews.childrenMatchingType(.Cell).elementBoundByIndex(0).otherElements.childrenMatchingType(.Image).element.coordinateWithNormalizedOffset(CGVector(dx: 0.5, dy: 0.5)).tap()
        
        let cells = app.tables.cells
        for _ in 0...12 {
            cells.elementBoundByIndex(1).tap()
        }
    }
    
    
    func testScrollDetail() {
        app.collectionViews.childrenMatchingType(.Cell).elementBoundByIndex(0).otherElements.childrenMatchingType(.Image).element.coordinateWithNormalizedOffset(CGVector(dx: 0.5, dy: 0.5)).tap()
        
        for _ in 0...2 {
            app.tables.element.swipeUp()
        }
    }
    
    func testShowYoutube() {
        
        app.collectionViews.childrenMatchingType(.Cell).elementBoundByIndex(0).otherElements.childrenMatchingType(.Image).element.coordinateWithNormalizedOffset(CGVector(dx: 0.5, dy: 0.5)).tap()
        
        let cells = app.tables.cells
        device.orientation = .LandscapeLeft
        cells.elementBoundByIndex(2).tap()
        
    }
    
}
