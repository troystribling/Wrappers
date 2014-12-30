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
        XCTAssert(mapped == 2.0, "optional flatmap some failed")
    }
    
    func testFlatmapNone() {
        let maybe : Int? = nil
        let mapped = flatmap(maybe){value -> Float? in
            return Optional(2.0*Float(value))
        }
        XCTAssert(mapped == nil, "optional flatmap none failed")
    }

    func testForeachSome() {
        let maybe : Int? = 1
        foreach(maybe){value in
            XCTAssert(value == 1, "optional foreach some failed")
        }
    }
    
    func testForeachNone() {
        let maybe : Int? = nil
        foreach(maybe){value in
            XCTAssert(false, "optional foreach none failed")
        }
    }
    
    func testFilterSome() {
        let maybe : Int? = 1
        let filtered = filter(maybe){value -> Bool in
            return true
        }
        XCTAssert(filtered == 1, "optional filtered some failed")
    }
    
    func testFilterFailedSome() {
        let maybe : Int? = 1
        let filtered = filter(maybe){value -> Bool in
            return false
        }
        XCTAssert(filtered == nil, "optional filter failed some failed")
    }
    
    func testFilterNone() {
        let maybe : Int? = nil
        let filtered = filter(maybe){value -> Bool in
            return true
        }
        XCTAssert(filtered == nil, "optional filtered some failed")
    }
    
    func testFlattenSome() {
        let maybe : Int?? = 1
        XCTAssert(flatten(maybe) == Optional(1), "optional flatten some failed")
    }
    
    func testFlattenNone() {
        let maybe : Int?? = nil
        XCTAssert(flatten(maybe) == Optional(), "optional flatten none failed")
    }
    
    func testForcompSuccess2Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 1.0
        var status = false
        forcomp(maybe1, maybe2) {(value1, value2) in
            XCTAssert(value1 == 1, "optional forcomp invalid value1")
            XCTAssert(value2 == 1.0, "optional forcomp invalid value2")
            status = true
        }
        XCTAssert(status, "optional forcomp success failed")
    }
    
    func testForcompFailure2Optionals() {
        let maybe1 : Int? = nil
        let maybe2 : Float? = 1.0
        forcomp(maybe1, maybe2) {(value1, value2) in
            XCTAssert(false, "optional forcomp apply called")
        }
        
    }

    func testForcompYieldSucces2Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 2.0
        let result = forcomp(maybe1, maybe2) {(value1, value2) -> Float in
            return Float(value1) * value2
        }
        XCTAssert(result == 2.0, "optional forcomp success failed")
    }
    
    func testForcompYieldFailure2Optionals() {
        let maybe1 : Int? = nil
        let maybe2 : Float? = 2.0
        let result = forcomp(maybe1, maybe2) {(value1, value2) -> Float in
            XCTAssert(false, "forcomp yield called")
            return 0.0
        }
        XCTAssert(result == nil, "optional forcomp failure failed")
    }

    func testForcompSuccess3Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 1.0
        let maybe3 : Int? = 1
        var status = false
        forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) in
            XCTAssert(value2 == 1.0, "optional forcomp invalid value1")
            XCTAssert(value1 == 1, "optional forcomp invalid value2")
            XCTAssert(value3 == 1, "optional forcomp invalid value3")
            status = true
        }
        XCTAssert(status, "optional forcomp success failed")
    }
    
    func testForcompFailure3Optionals() {
        let maybe1 : Int? = nil
        let maybe2 : Float? = 1.0
        let maybe3 : Int? = 1
        forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) in
            XCTAssert(false, "optional forcomp apply called")
        }
    }
    
    func testForcompYieldSuccess3Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 2.0
        let maybe3 : Int? = 3
        let result = forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) -> Int in
            return value1*Int(value2)*value3
        }
        XCTAssert(result == 6, "optional forcomp success failed")
    }
    
    func testForcompYieldFailure3Optionals() {
        let maybe1 : Int? = nil
        let maybe2 : Float? = 2.0
        let maybe3 : Int? = 3
        let result = forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) -> Int in
            XCTAssert(false, "optional forcomp yield called")
            return 0
        }
        XCTAssert(result == nil, "optional forcomp success failed")
    }

    func testForcompFilterSuccess2Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 1.0
        var applyStatus = false
        var filterStatus = false
        forcomp(maybe1, maybe2, filter:{(value1, value2) -> Bool in
                XCTAssert(value1 == 1, "optional forcomp filter nvalid value1")
                XCTAssert(value2 == 1.0, "optional forcomp filter invalid value2")
                filterStatus = true
                return true
            }) {(value1, value2) in
                XCTAssert(value1 == 1, "optional forcomp apply invalid value1")
                XCTAssert(value2 == 1.0, "optional forcomp apply invalid value2")
                applyStatus = true
            }
        XCTAssert(applyStatus || filterStatus, "optional forcomp filter success failed")

    }
    
    func testForcompFilterFailure2Optionals() {
        let maybe1 : Int? = 1
        let maybe2 : Float? = 1.0
        var status = false
        forcomp(maybe1, maybe2, filter:{(value1, value2) -> Bool in
                XCTAssert(value1 == 1, "optional forcomp filter nvalid value1")
                XCTAssert(value2 == 1.0, "optional forcomp filter invalid value2")
                status = true
                return false
            }) {(value1, value2) in
                XCTAssert(false, "optional forcomp apply called")
            }
        XCTAssert(status, "optional forcomp success failed")
    }
    
//    func testForcompFilterYieldSucces2Optionals() {
//        let maybe1 : Int? = 1
//        let maybe2 : Float? = 2.0
//        let result = forcomp(maybe1, maybe2) {(value1, value2) -> Float in
//            return Float(value1) * value2
//        }
//        XCTAssert(result == 2.0, "optional forcomp success failed")
//    }
//    
//    func testForcompFilterYieldFailure2Optionals() {
//        let maybe1 : Int? = 1
//        let maybe2 : Float? = 2.0
//        let result = forcomp(maybe1, maybe2) {(value1, value2) -> Float in
//            XCTAssert(false, "forcomp yield called")
//            return 0.0
//        }
//        XCTAssert(result == nil, "optional forcomp failure failed")
//    }
//    
//    func testForcompFilterSuccess3Optionals() {
//        let maybe1 : Int? = 1
//        let maybe2 : Float? = 1.0
//        let maybe3 : Int? = 1
//        forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) in
//            XCTAssert(value2 == 1.0, "optional forcomp success failed")
//            XCTAssert(value1 == 1, "optional forcomp success failed")
//            XCTAssert(value3 == 1, "optional forcomp success failed")
//        }
//    }
//    
//    func testForcompFilterFailure3Optionals() {
//        let maybe1 : Int? = 1
//        let maybe2 : Float? = 1.0
//        let maybe3 : Int? = 1
//        forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) in
//            XCTAssert(false, "optional forcomp apply called")
//        }
//    }
//    
//    func testForcompFilterYieldSuccess3Optionals() {
//        let maybe1 : Int? = 1
//        let maybe2 : Float? = 2.0
//        let maybe3 : Int? = 3
//        let result = forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) -> Int in
//            return value1*Int(value2)*value3
//        }
//        XCTAssert(result == 6, "optional forcomp success failed")
//    }
//    
//    func testForcompFilterYieldFailure3Optionals() {
//        let maybe1 : Int? = 1
//        let maybe2 : Float? = 2.0
//        let maybe3 : Int? = 3
//        let result = forcomp(maybe1, maybe2, maybe3) {(value1, value2, value3) -> Int in
//            XCTAssert(false, "optional forcomp yield called")
//            return 0
//        }
//        XCTAssert(result == nil, "optional forcomp success failed")
//    }

}
