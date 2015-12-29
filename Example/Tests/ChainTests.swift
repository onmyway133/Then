//
//  ChainTests.swift
//  Then
//
//  Created by Khoa Pham on 12/29/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import Then

class ChainTests: XCTestCase {
    func testChain() {
        let promise = Promise<Int>(result: .Fulfilled(value: 5))
            .then { result in
                if case let .Fulfilled(value) = result {
                    return .Fulfilled(value: value * 3)
                } else {
                    return result
                }
            }.then { result in
                if case let .Fulfilled(value) = result {
                    return .Fulfilled(value: value + 2)
                } else {
                    return result
                }
            }

        promise.then { result  in
            if case let .Fulfilled(value) = result {
                XCTAssert(value == 17)
            } else {
                XCTAssert(false)
            }

            return nil
        }
    }

    func testMap() {
        let promise1 = Promise<Int>()

        let promise2 = promise1.then { result in
            if case let .Fulfilled(value) = result {
                XCTAssert(value == 5)
                return .Fulfilled(value: value + 10)
            } else {
                return result
            }
        }

        promise2.then { result in
            if case let .Fulfilled(value) = result {
                XCTAssert(value == 15)
            } else {
                XCTAssert(false)
            }

            return nil
        }

        promise1.fulfill(value: 5)
    }

    func testFlatMap() {
        
    }

    func testAll() {
        let promise1 = Promise<Int>(result: .Fulfilled(value: 1))
        let promise2 = Promise<Int>(result: .Fulfilled(value: 2))

        let all = Promise.all([promise1, promise2])

        all.then { result in
            // TODO

            return nil
        }
    }
}
