//
//  OpionalTests.swift
//  Wrappers
//
//  Created by Troy Stribling on 12/30/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

import UIKit
import XCTest
import Wrappers

class OpionalTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testFlatmapSome() {
        let maybe : Int? = 1
        let mapped = flatmap(maybe){value -> Float? in
            return Optional(2.0*Float(value))
        }
        XCTAssert(mapped == 2.0, "Optional flatmap some failed")
    }
    
    func testFlatmapNone() {
        let maybe : Int? = nil
        let mapped = flatmap(maybe){value -> Float? in
            return Optional(2.0*Float(value))
        }
        XCTAssert(mapped == nil, "Optional flatmap none failed")
    }

    func testForeachSome() {
        let maybe : Int? = 1
        foreach(maybe){value in
            XCTAssert(value == 1, "Optional foreach some failed")
        }
    }
    
    func testForeachNone() {
        let maybe : Int? = nil
        foreach(maybe){value in
            XCTAssert(false, "Optional foreach none failed")
        }
    }
    
    func testFilterSome() {
        let maybe : Int? = 1
        let filtered = filter(maybe){value -> Bool in
            return true
        }
        XCTAssert(filtered == 1, "Optional filtered some failed")
    }
    
    func testFilterFailedSome() {
        let maybe : Int? = 1
        let filtered = filter(maybe){value -> Bool in
            return false
        }
        XCTAssert(filtered == nil, "Optional filter failed some failed")
    }
    
    func testFilterNone() {
        let maybe : Int? = nil
        let filtered = filter(maybe){value -> Bool in
            return true
        }
        XCTAssert(filtered == nil, "Optional filtered some failed")
    }
    
    func testFlattenSome() {
        let maybe : Int?? = 1
        XCTAssert(flatten(maybe) == Optional(1), "Optional flatten some failed")
    }
    
    func testFlattenNone() {
        let maybe : Int?? = nil
        XCTAssert(flatten(maybe) == Optional(), "Optional flatten none failed")
    }
    
    func testForcompSuccess2Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 1.0
        var status = false
        forcomp(maybe1, maybe2) {(value1, value2) in
            XCTAssert(value1 == 1, "Optional forcomp invalid value1")
            XCTAssert(value2 == 1.0, "Optional forcomp invalid value2")
            status = true
        }
        XCTAssert(status, "Optional forcomp apply not called")
    }
    
    func testForcompFailure2Optionals() {
        let maybe1 : Int? = nil
        let maybe2 : Float? = 1.0
        forcomp(maybe1, maybe2) {(value1, value2) in
            XCTAssert(false, "Optional forcomp apply called")
        }
        
    }

    func testForcompYieldSucces2Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 2.0
        let result = forcomp(maybe1, maybe2) {(value1, value2) -> Float in
            return Float(value1) * value2
        }
        XCTAssert(result == 2.0, "Optional forcomp failed")
    }
    
    func testForcompYieldFailure2Optionals() {
        let maybe1 : Int? = nil
        let maybe2 : Float? = 2.0
        let result = forcomp(maybe1, maybe2) {(value1, value2) -> Float in
            XCTAssert(false, "forcomp yield called")
            return 0.0
        }
        XCTAssert(result == nil, "Optional forcomp ffailed")
    }

    func testForcompSuccess3Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 1.0
        let maybe3 : Int? = 1
        var status = false
        forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) in
            XCTAssert(value2 == 1.0, "Optional forcomp invalid value1")
            XCTAssert(value1 == 1, "Optional forcomp invalid value2")
            XCTAssert(value3 == 1, "Optional forcomp invalid value3")
            status = true
        }
        XCTAssert(status, "Optional forcomp apply not called")
    }
    
    func testForcompFailure3Optionals() {
        let maybe1 : Int? = nil
        let maybe2 : Float? = 1.0
        let maybe3 : Int? = 1
        forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) in
            XCTAssert(false, "Optional forcomp apply called")
        }
    }
    
    func testForcompYieldSuccess3Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 2.0
        let maybe3 : Int? = 3
        let result = forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) -> Int in
            return value1*Int(value2)*value3
        }
        XCTAssert(result == 6, "Optional forcomp success failed")
    }
    
    func testForcompYieldFailure3Optionals() {
        let maybe1 : Int? = nil
        let maybe2 : Float? = 2.0
        let maybe3 : Int? = 3
        let result = forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) -> Int in
            XCTAssert(false, "Optional forcomp yield called")
            return 0
        }
        XCTAssert(result == nil, "Optional forcomp failed")
    }

    func testForcompFilterSuccess2Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 1.0
        var applyStatus = false
        var filterStatus = false
        forcomp(maybe1, maybe2, filter:{(value1, value2) -> Bool in
                XCTAssert(value1 == 1, "Optional forcomp filter nvalid value1")
                XCTAssert(value2 == 1.0, "Optional forcomp filter invalid value2")
                filterStatus = true
                return true
            }) {(value1, value2) in
                XCTAssert(value1 == 1, "Optional forcomp apply invalid value1")
                XCTAssert(value2 == 1.0, "Optional forcomp apply invalid value2")
                applyStatus = true
            }
        XCTAssert(applyStatus, "Optional forcomp apply not called")
        XCTAssert(filterStatus, "Optional forcomp filter not called")

    }
    
    func testForcompFilterFailure2Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 1.0
        var status = false
        forcomp(maybe1, maybe2, filter:{(value1, value2) -> Bool in
                XCTAssert(value1 == 1, "Optional forcomp filter nvalid value1")
                XCTAssert(value2 == 1.0, "Optional forcomp filter invalid value2")
                status = true
                return false
            }) {(value1, value2) in
                XCTAssert(false, "Optional forcomp apply called")
            }
        XCTAssert(status, "Optional forcomp filter not called")
    }
    
    func testForcompFilterYieldSucces2Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 2.0
        var status = false
        let result = forcomp(maybe1, maybe2, filter:{(value1, value2) -> Bool in
                XCTAssert(value1 == 1, "Optional forcomp filter nvalid value1")
                XCTAssert(value2 == 2.0, "Optional forcomp filter invalid value2")
                status = true
                return true
            }) {(value1, value2) -> Float in
                return Float(value1) * value2
            }
        XCTAssert(result == 2.0, "Optional forcomp failed")
        XCTAssert(status, "Optional forcomp filter not called")
    }
    
    func testForcompFilterYieldFailure2Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 2.0
        var status = false
        let result = forcomp(maybe1, maybe2, filter:{(value1, value2) -> Bool in
                XCTAssert(value1 == 1, "Optional forcomp filter nvalid value1")
                XCTAssert(value2 == 2.0, "Optional forcomp filter invalid value2")
                status = true
                return false
            }) {(value1, value2) -> Float in
                XCTAssert(false, "forcomp yield called")
                return 0.0
            }
        XCTAssert(status, "Optional forcomp filter not called")
    }
    
    func testForcompFilterSuccess3Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 1.0
        let maybe3 : Int? = 1
        var filterStatus = false
        var applyStatus = false
        forcomp(maybe1, maybe2, maybe3, filter:{(value1, value2, value3) -> Bool in
                XCTAssert(value1 == 1, "Optional forcomp filter nvalid value1")
                XCTAssert(value2 == 1.0, "Optional forcomp filter invalid value2")
                XCTAssert(value3 == 1, "Optional forcomp filter invalid value3")
                filterStatus = true
                return true
            }) {(value1, value2, value3) in
                XCTAssert(value2 == 1.0, "Optional forcomp success failed")
                XCTAssert(value1 == 1, "Optional forcomp success failed")
                XCTAssert(value3 == 1, "Optional forcomp success failed")
                applyStatus = true
            }
        XCTAssert(filterStatus, "Optional forcomp filter not called")
        XCTAssert(applyStatus, "Optional forcomp apply not called")
    }

    func testForcompFilterFailure3Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 1.0
        let maybe3 : Int? = 1
        var status = false
        forcomp(maybe1, maybe2, maybe3, filter:{(value1, value2, value3) -> Bool in
                XCTAssert(value1 == 1, "Optional forcomp filter nvalid value1")
                XCTAssert(value2 == 1.0, "Optional forcomp filter invalid value2")
                XCTAssert(value3 == 1, "Optional forcomp filter invalid value3")
                status = true
                return false
            }) {(value1, value2, value3) in
                XCTAssert(false, "Optional forcomp apply called")
            }
        XCTAssert(status, "Optional forcomp filter not called")
    }
    
    func testForcompFilterYieldSuccess3Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 2.0
        let maybe3 : Int? = 3
        var status = false
        let result = forcomp(maybe1, maybe2, maybe3, filter:{(value1, value2, value3) -> Bool in
                XCTAssert(value1 == 1, "Optional forcomp filter nvalid value1")
                XCTAssert(value2 == 2.0, "Optional forcomp filter invalid value2")
                XCTAssert(value3 == 3, "Optional forcomp filter invalid value3")
                status = true
                return true
            }) {(value1, value2, value3) -> Int in
                return value1*Int(value2)*value3
            }
        XCTAssert(result == 6, "Optional forcomp failed")
        XCTAssert(status, "Optional forcomp filter not called")
    }
    
    func testForcompFilterYieldFailure3Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 2.0
        let maybe3 : Int? = 3
        var status = false
        let result = forcomp(maybe1, maybe2, maybe3, filter:{(value1, value2, value3) -> Bool in
                XCTAssert(value1 == 1, "Optional forcomp filter nvalid value1")
                XCTAssert(value2 == 2.0, "Optional forcomp filter invalid value2")
                XCTAssert(value3 == 3, "Optional forcomp filter invalid value3")
                status = true
                return false
            }) {(value1, value2, value3) -> Int in
                XCTAssert(false, "Optional forcomp yield called")
                return 0
            }
        XCTAssert(result == nil, "Optional forcomp failed")
        XCTAssert(status, "Optional forcomp filter not called")
    }

}
