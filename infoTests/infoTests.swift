//
//  infoTests.swift
//  infoTests
//
//  Created by Rodrigo Nóbrega on 8/19/16.
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import XCTest

@testable import info

class infoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConfigCall() {
        
        Connection.configApplication({ (message) in }) { (error) in }

    }
    
    func testPerformance() {
        self.measureBlock {
            let movie = MovieCollectionViewController()
            for _ in 0...300 {
                movie.loadBegin()
            }
        }
    }
    
}
