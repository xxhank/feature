//
//  Business.swift
//  Pods
//
//  Created by wangchao9 on 16/4/4.
//
//

import Foundation
import SwiftTask

public class BusinessTask<Progress, Value, Error>: Task<Progress, Value, Error> {
    public override init(weakified: Bool, paused: Bool, initClosure: InitClosure) {
        super.init(weakified: weakified, paused: paused, initClosure: initClosure)
    }

    ///
    /// Create a new task without weakifying progress/fulfill/reject handlers
    ///
    /// - e.g. Task<P, V, E>(paused: false) { progress, fulfill, reject, configure in ... }
    ///
    public convenience init(paused: Bool, initClosure: InitClosure) {
        self.init(weakified: false, paused: paused, initClosure: initClosure)
    }

    ///
    /// Create a new task without weakifying progress/fulfill/reject handlers (non-paused)
    ///
    /// - e.g. Task<P, V, E> { progress, fulfill, reject, configure in ... }
    ///
    public convenience init(initClosure: InitClosure) {
        self.init(weakified: false, paused: false, initClosure: initClosure)
    }

    ///
    /// Create fulfilled task (non-paused)
    ///
    /// - e.g. Task<P, V, E>(value: someValue)
    ///
    public convenience init(value: Value) {
        self.init(initClosure: { progress, fulfill, reject, configure in
            fulfill(value)
        })
        self.name = "FulfilledTask"
    }

    ///
    /// Create rejected task (non-paused)
    ///
    /// - e.g. Task<P, V, E>(error: someError)
    ///
    public convenience init(error: Error) {
        self.init(initClosure: { progress, fulfill, reject, configure in
            reject(error)
        })
        self.name = "RejectedTask"
    }

    ///
    /// Create promise-like task which only allows fulfill & reject (no progress & configure)
    ///
    /// - e.g. Task<Any, Value, Error> { fulfill, reject in ... }
    ///
    public convenience init(promiseInitClosure: PromiseInitClosure) {
        self.init(initClosure: { progress, fulfill, reject, configure in
            promiseInitClosure(fulfill: fulfill, reject: { error in reject(error) })
        })
    }

    deinit {
        print("\(self) died at \(NSDate())")
    }
}
public enum BusinessTypes<Result> {
    public typealias Task = BusinessTask<Float, Result, NSError>
}

public protocol SSCancelable: class {
    func cancel();
}

public class Business {
    required public init() {
    }

    public func runTask<Result>(requestBlock: (fulfill: (Result -> Void),
        reject: (NSError -> Void)) -> SSCancelable?)
        -> BusinessTypes<Result>.Task {
            let task = BusinessTypes<Result>.Task { progress, fulfill, reject, configure in
                let request = requestBlock(fulfill: fulfill, reject: reject)
                configure.cancel = { [weak request] in
                    request?.cancel()
                }
            }
            return task
    }

    public func cancelSubTask<T>(parent: BusinessTypes<T>.Task) {
        // Implement in sub class
    }

    public func cancel<T>(task: BusinessTypes<T>.Task) {
        cancelSubTask(task)
        task.cancel()
    }
}

public protocol SupportBusiness {
    func setBusiness(business: Business?)
}