//
//  Thenable.swift
//  Pods
//
//  Created by Khoa Pham on 12/29/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation

public protocol Thenable {
    typealias Value

    func then<U>(queue: dispatch_queue_t, map: Result<Value> -> Result<U>) -> Self
}