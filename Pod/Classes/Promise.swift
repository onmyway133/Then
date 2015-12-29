//
//  Promise.swift
//  Pods
//
//  Created by Khoa Pham on 12/28/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation

public final class Promise<T> {
    public typealias Value = T

    var result: Result<T> = .Pending
    let lockQueue = dispatch_queue_create("lock_queue", DISPATCH_QUEUE_SERIAL)
    var callbacks = [Callback<T>]()
    public let key = NSUUID().UUIDString

    public init(result: Result<T> = .Pending) {
        self.result = result
    }

    public func then<U>(queue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0),
        map: Result<T> -> Result<U>?) -> Promise<U> {

            let promise = Promise<U>()

            register(queue: queue) { result in
                promise.notify(result: map(result))
            }

            notify(result: result)

            return promise
    }

    public func reject(reason reason: ErrorType) {
        dispatch_sync(lockQueue) {
            guard self.result.isPending() else {
                return
            }

            self.result = .Rejected(reason: reason)
            self.notify(result: self.result)
        }
    }

    public func fulfill(value value: T) {
        dispatch_sync(lockQueue) {
            guard self.result.isPending() else {
                return
            }

            self.result = .Fulfilled(value: value)
            self.notify(result: self.result)
        }
    }

    private func notify(result result: Result<T>?) {
        guard let result = result where !result.isPending() else {
            return
        }

        self.result = result

        callbacks.forEach { callback in
            dispatch_async(callback.queue) {
                callback.completion(result)
            }
        }

        callbacks.removeAll()
    }

    private func register(queue queue: dispatch_queue_t, completion: Result<T> -> Void) {
        let callback = Callback(completion: completion, queue: queue)
        callbacks.append(callback)
    }

    public class func all(promises promises: [Promise]) -> Promise<[String: T]> {
        let final = Promise<[String: T]>()

        let total = promises.count
        var count = 0
        var values = [String: T]()

        promises.forEach { promise in
            promise.then { result in
                dispatch_sync(final.lockQueue) {
                    if !final.result.isPending() {
                        return
                    }

                    switch result {
                    case let .Rejected(reason):
                        final.reject(reason: reason)
                    case let .Fulfilled(value):
                        count++
                        values[promise.key] = value

                        if count == total {
                            final.fulfill(value: values)
                        }
                    default:
                        break
                    }
                }
                
                return nil
            } as Promise<T>
        }

        return final
    }
}