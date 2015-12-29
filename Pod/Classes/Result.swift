//
//  Result.swift
//  Pods
//
//  Created by Khoa Pham on 12/29/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation

enum Result<T> {
    case Pending
    case Fulfilled(value: T)
    case Rejected(reason: ErrorType)

    func isPending() -> Bool {
        if case .Pending = self {
            return true
        } else {
            return false
        }
    }
}