//
//  TryTests.swift
//  Wrappers
//
//  Created by Troy Stribling on 12/30/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

import UIKit
import XCTest
import Wrappers

struct TestFailure {
    static let error = NSError(domain:"Wrappers Tests", code:100, userInfo:[NSLocalizedDescriptionKey:"Testing"])
}

func shouldSucceed<T:Equatable>(try:Try<T>, value:T) {
    switch try {
    case .Success(let box):
        XCTAssert(box.value == value, "Try value invalid")
    case .Failure(let error):
        XCTAssert(false, "Try should succed")
    }
}

func shouldFail<T>(try:Try<T>, testError:NSError) {
    var status = false
    switch try {
    case .Success(let box):
        XCTAssert(false, "Try should fail")
    case .Failure(let error):
        XCTAssert(error.code == testError.code, "Try error code invalid")
        XCTAssert(error.domain == testError.domain, "Try error domin invalid")
        status = true
    }
    XCTAssert(status, "Try should fail")
}

class TryTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testIsFailureSuccess() {
        XCTAssert(Try<Bool>(TestFailure.error).isFailure(), "Try isFailure failed")
    }
    
    func testIsFailedFailure() {
        XCTAssert(Try(false).isFailure() == false, "Try isFailure failed")
    }
    
    func testIsSuccessSuccess() {
        XCTAssert(Try(false).isSuccess(), "Try isSuccess failed")
    }
    
    func testIsSuccessFailure() {
        XCTAssert(Try<Bool>(TestFailure.error).isSuccess() == false, "Try isSuccess failed")
    }
    
    func testMapSuccess() {
        let try = Try(true)
        let mapped = try.map {value -> Int in
            return 1
        }
        shouldSucceed(mapped, 1)
    }
    
    func testMapFailue() {
        let try = Try<Bool>(TestFailure.error)
        let mapped = try.map{value -> Int in
            return 1
        }
        shouldFail(mapped, TestFailure.error)
    }
    
    func testFlatmapSuccess() {
        let try = Try(true)
        let mapped = try.flatmap {value -> Try<Int> in
            return Try(1)
        }
        shouldSucceed(mapped, 1)
    }
    
    func testFlatmapFailue() {
        let try = Try<Bool>(TestFailure.error)
        let mapped = try.flatmap{value -> Try<Int> in
            return Try(1)
        }
        shouldFail(mapped, TestFailure.error)
    }

    func testFailedFlatmap() {
        let try = Try(true)
        let mapped = try.flatmap {value -> Try<Int> in
            return Try<Int>(TestFailure.error)
        }
        shouldFail(mapped, TestFailure.error)
    }

    func testRecoverSuccess() {
        let try = Try(true)
        let recovered = try.recover {error in
            XCTAssert(false, "Try recovery called")
            return false
        }
        shouldSucceed(recovered, true)
    }
    
    func testRecoverFailure() {
        let try = Try<Bool>(TestFailure.error)
        let recovered = try.recover {error in
            return false
        }
        shouldSucceed(recovered, false)
    }

    func testRecoveWithSuccess() {
        let try = Try(true)
        let recovered = try.recoverWith {error in
            XCTAssert(false, "Try recovery called")
            return Try(false)
        }
        shouldSucceed(recovered, true)
    }
    
    func testRecoverWithFailure() {
        let try = Try<Bool>(TestFailure.error)
        let recovered = try.recoverWith {error in
            return Try(false)
        }
        shouldSucceed(recovered, false)
    }

    func testForeachSuccess() {
        var status = false
        let try = Try(true)
        try.foreach {value in
            XCTAssert(value, "Try foreach invalid value")
            status = true
        }
        XCTAssert(status, "Try foreach failed")
    }
    
    func testForeachFailure() {
        let try = Try<Bool>(TestFailure.error)
        try.foreach {value in
            XCTAssert(false, "Try foreach called")
        }
    }
    
    func testFilterSuccess() {
        let try = Try(true)
        var status = false
        let filtered = try.filter {value in
            status = true
            return value
        }
        XCTAssert(status, "Try filter not called")
        shouldSucceed(filtered, true)
    }
    
    func testFailedFilter() {
        let try = Try(false)
        let filtered = try.filter {value in
            return value
        }
        shouldFail(filtered, TryError.filterFailed)
    }
    
    func testFilterFailure() {
        let try = Try<Bool>(TestFailure.error)
        let filtered = try.filter {value in
            XCTAssert(false, "Try Filter called")
            return value
        }
        shouldFail(filtered, TestFailure.error)
    }
    
    func testToOptionalSuccess() {
        let try = Try(true)
        let opt = try.toOptional()
        XCTAssert(opt == true, "Try toOption failed")
    }
    
    func testToOptionalFailure() {
        let try = Try<Bool>(TestFailure.error)
        let opt = try.toOptional()
        XCTAssert(opt == nil, "Try toOption failed")
    }
    
    
    func testGetOrElseSuccess() {
        let try = Try(true)
        XCTAssert(try.getOrElse(false) == true, "Try getOrElse failed")
    }
    
    func testGetOrElseFailure() {
        let try = Try<Bool>(TestFailure.error)
        XCTAssert(try.getOrElse(false) == false, "Try getOrElse failed")
    }
    
    func testOrElseSuccess() {
        let try = Try(true)
        shouldSucceed(try.orElse(Try(false)), true)
    }
    
    func testOrElseFailure() {
        let try = Try<Bool>(TestFailure.error)
        shouldSucceed(try.orElse(Try(false)), false)
    }
    
    func testFlattenSuccess() {
        let try = Try(Try(true))
        shouldSucceed(flatten(try), true)
    }
    
    func testFlattenFailure() {
        let try = Try(Try<Bool>(TestFailure.error))
        shouldFail(try, TestFailure.error)
    }
    
    func testForcompSuccess2Trys() {
        
    }
    
    func testForcompFailure2Trys() {
        
    }
    
    func testForcompYieldSucces2Trys() {
        
    }
    
    func testForcompYieldFailure2Trys() {
        
    }
    
    func testForcompSuccess3Trys() {
        
    }
    
    func testForcompFailure3Trys() {
        
    }
    
    func testForcompYieldSuccess3Trys() {
        
    }
    
    func testForcompYieldFailure3Trys() {
        
    }

    func testForcompFilterSuccess2Trys() {
        
    }
    
    func testForcompFilterFailure2Trys() {
        
    }
    
    func testForcompFilterYieldSucces2Trys() {
        
    }
    
    func testForcompFilterYieldFailure2Trys() {
        
    }
    
    func testForcompFilterSuccess3Trys() {
        
    }
    
    func testForcompFilterFailure3Trys() {
        
    }
    
    func testForcompFilterYieldSuccess3Trys() {
        
    }
    
    func testForcompFilterYieldFailure3Trys() {
        
    }

}
