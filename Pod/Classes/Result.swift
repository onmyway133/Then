//
//  Result.swift
//  Pods
//
//  Created by Khoa Pham on 12/29/15.
//  Copyright © 2015 Fantageek. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Pending
    case Fulfilled(value: T)
    case Rejected(reason: ErrorType)

    func map<U>(f: T -> U) -> Result<U> {
        switch self {
        case let .Fulfilled(value):
            return .Fulfilled(value: f(value))
        case let .Rejected(reason):
            return Result<U>.Rejected(reason: reason)
        case .Pending:
            return Result<U>.Pending
        }
    }

    func isPending() -> Bool {
        if case .Pending = self {
            return true
        } else {
            return false
        }
    }
}