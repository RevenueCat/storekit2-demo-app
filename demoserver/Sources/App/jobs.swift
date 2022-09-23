//
//  File.swift
//  
//
//  Created by Josh Holtz on 9/21/22.
//

import Vapor
import Foundation
import Queues

struct AppleNotificationJob: Job {
    typealias Payload = NotificationPayload

    func dequeue(_ context: QueueContext, _ payload: NotificationPayload) -> EventLoopFuture<Void> {
        // This is where you would send the email
        return context.eventLoop.future()
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: NotificationPayload) -> EventLoopFuture<Void> {
        // If you don't want to handle errors you can simply return a future. You can also omit this function entirely.
        return context.eventLoop.future()
    }
}
