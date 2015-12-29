//
//  Promise.swift
//  Pods
//
//  Created by Khoa Pham on 12/28/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation

final class Promise<T>: Thenable {
    typealias Value = T
    var result: Result<T> = .Pending

    let lockQueue = dispatch_queue_create("lock_queue", DISPATCH_QUEUE_SERIAL)
    var callbacks = [Callback<T>]()

    init() {
        
    }

    func then(queue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0),
        completion: Result<T> -> Result<T>?) -> Promise {

            let promise = Promise()
            let callback = Callback(promise: promise, completion: completion, queue:queue)

            callbacks.append(callback)
            notify(callback: callback, result: result)

            return promise
    }

    func notify(callback callback: Callback<T>, result: Result<T>) {
        dispatch_async(callback.queue) {
            let r = callback.completion(self.result)
            self.handle(promise: callback.promise, result: r)
        }
    }

    func handle(promise promise: Promise, result: Result<T>?) {
        guard let result = result else {
            return
        }

        switch result {
        case let .Rejected(reason):
            promise.reject(reason: reason)
        case let .Fulfilled(value):
            if let anotherPromise = value as? Promise {
                promise.forward(promise: promise, anotherPromise: anotherPromise)
            } else {
                promise.fulfill(value: value)
            }
        default:
            break
        }
    }

    func reject(reason reason: ErrorType) {
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

    func fulfill(value value: T) {
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

    func forward(promise promise: Promise, anotherPromise: Promise) {

    }
}