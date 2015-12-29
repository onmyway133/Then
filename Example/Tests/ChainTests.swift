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
        let promise = (Promise<String>(result: .Fulfilled(value: "then"))
            .then { result in
                return result.map { value in
                    return value.characters.count
                }
            } as Promise<Int>)
            .then { result in
                return result.map { value in
                    return value * 2
                }
            } as Promise<Int>

        promise.then { result in
            if case let .Fulfilled(value) = result {
                XCTAssert(value == 8)
            } else {
                XCTAssert(false)
            }

            return nil
        } as Promise<Int>
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
        } as Promise<Int>

        promise2.then { result in
            if case let .Fulfilled(value) = result {
                XCTAssert(value == 15)
            } else {
                XCTAssert(false)
            }

            return nil
        } as Promise<Int>

        promise1.fulfill(value: 5)
    }

    func testAll() {
        let promise1 = Promise<Int>(result: .Fulfilled(value: 1))
        let promise2 = Promise<Int>(result: .Fulfilled(value: 2))
        let promise3 = Promise<Int>(result: .Fulfilled(value: 3))

        let final = Promise.all(promises: [promise1, promise2, promise3])

        final.then { result in
            if case let .Fulfilled(value) = result {
                XCTAssert(value.count == 3)

                XCTAssert(value.values.contains(1))
                XCTAssert(value.values.contains(2))
                XCTAssert(value.values.contains(3))

                XCTAssert(value.keys.contains(promise1.key))
            } else {
                XCTAssert(false)
            }

            return nil
        } as Promise<Any>
    }
}
