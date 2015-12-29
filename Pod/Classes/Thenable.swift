//
//  Thenable.swift
//  Pods
//
//  Created by Khoa Pham on 12/29/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation

protocol Thenable {
    typealias Value

    func then(queue: dispatch_queue_t, completion: Result<Value> -> Result<Value>?) -> Self
}