//
//  Try.swift
//  Wrappers
//
//  Created by Troy Stribling on 12/21/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

import Foundation

public enum Try<T> {

    case Success(Box<T>)
    case Failure(NSError)
    
    public init(_ value:T) {
        self = .Success(Box(value))
    }
    
    public init(_ error:NSError) {
        self = .Failure(error)
    }
    
    public func map<M>(mapping:T -> M) -> Try<M> {
        switch self {
        case .Success(let box):
            return Try<M>(mapping(box.value))
        case .Failure(let error):
            return Try<M>(error)
        }
    }
    
    public func flatmap<M>(mapping:T -> Try<M>) -> Try<M> {
        switch self {
        case .Success(let box):
            return mapping(box.value)
        case .Failure(let error):
            return Try<M>(error)
        }
    }
    
    public func recover(recovery:NSError -> T) -> Try<T> {
        switch self {
        case .Success:
            return self
        case .Failure(let error):
            return Try(recovery(error))
        }
    }
    
}

public func map<M, T>(try:Try<T>, mapping:T -> M) -> Try<M> {
    return try.map(mapping)
}

public func flatmap<M, T>(try:Try<T>, mapping:T -> Try<M>) -> Try<M> {
    return try.flatmap(mapping)
}

