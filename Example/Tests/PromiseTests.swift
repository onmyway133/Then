//
//  PromiseTests.swift
//  Then
//
//  Created by Khoa Pham on 12/29/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import Then

class PromiseTests: XCTestCase {
    func testThen() {
        let promise = Promise(result: Result.Fulfilled(value: 5))

        let expectation = expectationWithDescription("")

        var count = 0
        promise.then { _ in
            count++
            return nil
        } as Promise<Any>

        promise.then { _ in
            count++

            expectation.fulfill()
            XCTAssert(count == 2)

            return nil
        } as Promise<Any>

        waitForExpectationsWithTimeout(0.5, handler: nil)
    }

    func testThenWhenPending() {
        let promise = Promise<Int>()

        promise.then { _ in
            XCTAssert(false)

            return nil
        } as Promise<Any>
    }

    func testRejectedAfterFulfilled() {
        let promise = Promise(result: Result.Fulfilled(value: 5))

        promise.then { _ in
            XCTAssert(true)

            return nil
        } as Promise<Any>

        promise.reject(reason: NSError(domain: "", code: 0, userInfo: nil))

        promise.then { result in
            if case .Rejected = result {
                XCTAssert(false)
            }

            return nil
        } as Promise<Any>
    }
}
