//
//  Promise.swift
//  Pods
//
//  Created by Khoa Pham on 12/28/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation

public final class Promise<T>: Thenable {
    public typealias Value = T

    var result: Result<T> = .Pending
    let lockQueue = dispatch_queue_create("lock_queue", DISPATCH_QUEUE_SERIAL)
    var callbacks = [Callback<T>]()
    public let key = NSUUID().UUIDString

    public init(result: Result<T> = .Pending) {
        self.result = result
    }

    public func then(queue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0),
        completion: Result<T> -> Result<T>?) -> Promise {

            let promise = Promise()
            let callback = Callback(promise: promise, completion: completion, queue:queue)

            callbacks.append(callback)

            if !result.isPending() {
                notify(callback: callback, result: result)
            }

            return promise
    }

    private func notify(callback callback: Callback<T>, result: Result<T>) {
        dispatch_async(callback.queue) {
            let transformedResult = callback.completion(self.result)
            callback.promise.handle(result: transformedResult)
        }
    }

    private func handle(result result: Result<T>?) {
        guard let result = result else {
            return
        }

        switch result {
        case let .Rejected(reason):
            reject(reason: reason)
        case let .Fulfilled(value):
            if let anotherPromise = value as? Promise {
                forward(anotherPromise: anotherPromise)
            } else {
                fulfill(value: value)
            }
        default:
            break
        }
    }

    public func reject(reason reason: ErrorType) {
        dispatch_sync(lockQueue) {
            guard self.result.isPending() else {
                return
            }

            self.result = .Rejected(reason: reason)

            self.callbacks.forEach { callback in
                self.notify(callback: callback, result: self.result)
            }

            self.callbacks.removeAll()
        }
    }

    public func fulfill(value value: T) {
        dispatch_sync(lockQueue) {
            guard self.result.isPending() else {
                return
            }

            self.result = .Fulfilled(value: value)

            self.callbacks.forEach { callback in
                self.notify(callback: callback, result: self.result)
            }

            self.callbacks.removeAll()
        }
    }

    // TODO
    private func forward(anotherPromise anotherPromise: Promise) {
        anotherPromise.then { [unowned self] (result: Result<T>) -> Result<T>? in
            switch result {
            case let .Rejected(reason):
                self.reject(reason: reason)
            case let .Fulfilled(value):
                self.fulfill(value: value)
            default:
                break
            }

            return nil
        }
    }

    class func all(promises: [Promise]) -> Promise {
        let final = Promise()

        let total = promises.count
        var count = 0
        var values = [String: T]()

        promises.forEach { promise in
            promise.then { result in
                dispatch_sync(final.lockQueue) {
                    if !final.result.isPending() {
                        // TODO
                        return
                    }

                    switch result {
                    case let .Rejected(reason):
                        final.reject(reason: reason)
                    case let .Fulfilled(value):
                        count++

                        values[promise.key] = value

                        if count == total {
                            // TODO
//                            final.fulfill(value: values)
                        }
                    default:
                        break
                    }
                }

                return nil
            }
        }

        return final
    }
}