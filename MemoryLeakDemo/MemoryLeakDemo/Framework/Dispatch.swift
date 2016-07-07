//
//  Dispatch.swift
//  Pods
//
//  Created by wangchao9 on 16/4/4.
//
//

import Foundation

public class Dispatch {
    public enum QueueIdentifier {
        case USER_INTERACTIVE
        case USER_INITIATED
        case DEFAULT
        case UTILITY
        case BACKGROUND
        // case CUSTOM(qos: qos_class_t)

        var qos: qos_class_t {
            switch self {
            case .USER_INTERACTIVE: return QOS_CLASS_USER_INTERACTIVE
            case .USER_INITIATED: return QOS_CLASS_USER_INITIATED
            case .DEFAULT: return QOS_CLASS_DEFAULT
            case .UTILITY: return QOS_CLASS_UTILITY
            case .BACKGROUND: return QOS_CLASS_BACKGROUND
                // case .CUSTOM(let qos): return qos
            }
        }
    }
    public class func sync_on_ui(block: dispatch_block_t) {
        if NSThread.isMainThread() {
            block()
        } else {
            dispatch_sync(dispatch_get_main_queue(), block)
        }
    }

    /**
     sync_in_background

     - parameter identifier:     see identifier
     - parameter block:          block to execute

     identifier
     - QOS_CLASS_USER_INTERACTIVE
     - QOS_CLASS_USER_INITIATED
     - QOS_CLASS_DEFAULT
     - QOS_CLASS_UTILITY
     - QOS_CLASS_BACKGROUND
     */
    public class func sync_in_global(identifier: QueueIdentifier = .BACKGROUND, block: dispatch_block_t) {
        // dispatch_sync(dispatch_get_global_queue(identifier, 0), block)
    }

    public class func async_on_ui(block: dispatch_block_t) {
        if NSThread.isMainThread() {
            block()
        } else {
            dispatch_async(dispatch_get_main_queue(), block)
        }
    }

    /**
     async_in_background

     - parameter identifier:     see identifier
     - parameter block:          block to execute

     identifier
     - QOS_CLASS_USER_INTERACTIVE
     - QOS_CLASS_USER_INITIATED
     - QOS_CLASS_DEFAULT
     - QOS_CLASS_UTILITY
     - QOS_CLASS_BACKGROUND
     */
    public class func async_in_global(identifier: QueueIdentifier = .BACKGROUND, block: dispatch_block_t) {
        dispatch_async(dispatch_get_global_queue(identifier.qos, 0), block)
    }

    public class func after_on_ui(delayInSeconds: NSTimeInterval, block: dispatch_block_t) {
        Dispatch.after_in_queue(delayInSeconds, queue: dispatch_get_main_queue(), block: block)
    }

    /**
     dispatch_after

     - parameter delayInSeconds:
     - parameter identifier:     see identifier
     - parameter block:          block to execute

     identifier
     - QOS_CLASS_USER_INTERACTIVE
     - QOS_CLASS_USER_INITIATED
     - QOS_CLASS_DEFAULT
     - QOS_CLASS_UTILITY
     - QOS_CLASS_BACKGROUND
     */
    public class func after_in_global(delayInSeconds: NSTimeInterval, identifier: QueueIdentifier = .BACKGROUND, block: dispatch_block_t) {
        Dispatch.after_in_queue(delayInSeconds, queue: dispatch_get_global_queue(identifier.qos, 0), block: block)
    }
    public class func after_in_queue(delayInSeconds: NSTimeInterval, queue: dispatch_queue_t, block: dispatch_block_t) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(UInt64(delayInSeconds) * NSEC_PER_SEC)), queue, block)
    }

    public class func queue(label: String, concurrent: Bool = true) -> dispatch_queue_t {
        return dispatch_queue_create(label, concurrent ? DISPATCH_QUEUE_CONCURRENT : DISPATCH_QUEUE_SERIAL)
    }
}