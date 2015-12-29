//
//  Callback.swift
//  Pods
//
//  Created by Khoa Pham on 12/29/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation

struct Callback<T> {
    let promise: Promise<T>
    let completion: Result<T> -> Result<T>?
    let queue: dispatch_queue_t
}