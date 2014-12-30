//
//  BoxTests.swift
//  Wrappers
//
//  Created by Troy Stribling on 12/30/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

import UIKit
import XCTest
import Wrappers

class BoxTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testMap() {
        let box = Box(1)
        XCTAssert(box.map{2*$0}.value == 2, "mapped value invalid")
    }
    
    func testFlatmap() {
        let box = Box(1)
        XCTAssert(box.flatmap{Box(2*$0)}.value == 2, "mapped value invalid")
    }
}
