//
//  StateTests.swift
//  Then
//
//  Created by Khoa Pham on 12/29/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import Then

class StateTests: XCTestCase {

    func testPending() {
        let promise = Promise<Int>()

        XCTAssert(promise.result.isPending())
    }

    func testFulfilled() {
        let promise = Promise<Int>()

        promise.then { result in
            var condition = false
            if case let .Fulfilled(value) = result where value == 10 {
                condition = true
            }

            XCTAssert(condition)

            return nil
        }

        promise.fulfill(value: 10)
    }

    func testRejected() {
        let promise = Promise<Int>()
        let error = NSError(domain: "test", code: 0, userInfo: nil)

        promise.then { result in
            var condition = false
            if case let .Rejected(reason) = result {
                let e = reason as NSError

                if e == error {
                    condition = true
                }
            }

            XCTAssert(condition)

            return nil
        }
        
        promise.reject(reason: error)
    }
}