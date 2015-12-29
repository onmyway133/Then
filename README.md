# Then
[Promise A+](https://promisesaplus.com/) in Swift

[![CI Status](http://img.shields.io/travis/Khoa Pham/Then.svg?style=flat)](https://travis-ci.org/Khoa Pham/Then)
[![Version](https://img.shields.io/cocoapods/v/Then.svg?style=flat)](http://cocoapods.org/pods/Then)
[![License](https://img.shields.io/cocoapods/l/Then.svg?style=flat)](http://cocoapods.org/pods/Then)
[![Platform](https://img.shields.io/cocoapods/p/Then.svg?style=flat)](http://cocoapods.org/pods/Then)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Features

- Use Result to associate states with values
- Support protocol `Thenable`
- Support queue

### Then

```swift
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
```

### Chain

```swift
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
```

### All

```swift
let promise1 = Promise<Int>(result: .Fulfilled(value: 1))
let promise2 = Promise<Int>(result: .Fulfilled(value: 2))

let all = Promise.all([promise1, promise2])

all.then { result in
    // TODO

    return nil
}
```

## Installation

Then is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Then"
```

## Author

Khoa Pham, onmyway133@gmail.com

## License

Then is available under the MIT license. See the LICENSE file for more info.
