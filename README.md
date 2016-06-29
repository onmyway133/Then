# Then
<a href="https://promisesaplus.com/">
    <img src="https://promisesaplus.com/assets/logo-small.png" alt="Promises/A+ logo"
         title="Promises/A+ 1.0 compliant" align="top" />
</a>

[Promise A+](https://promisesaplus.com/) in Swift

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Features

- Use Result to associate states with values
- Support protocol `Thenable`
- Support queue
- Transform Fulfilled value

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
} as Promise<Any>

promise.fulfill(value: 10)
```

### Chain

```swift
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
} as Promise<Any>
}
```

### All

```swift
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
```

## Installation

Then is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Then', git: 'https://github.com/onmyway133/Then'
```

## Author

Khoa Pham, onmyway133@gmail.com

## License

Then is available under the MIT license. See the LICENSE file for more info.
