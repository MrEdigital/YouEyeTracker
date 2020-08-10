///
///  SubscriptionManager_Management_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// SubscriptionManager Unit Tests - Management
///
class SubscriptionManager_Management_Tests: XCTestCase {
    
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func subscribe(_ subscriber: T)
///     private func compact()
///
extension SubscriptionManager_Management_Tests {
    
    // MARK: - T - Subscribe
    ///
    /// Tests the function:
    ///
    ///     func subscribe(_ subscriber: T)
    ///
    /// The following behavior is expected:
    /// 1. As objects are subscribed to the SubscriptionManager they should be wrapped and added to its subscribers array
    ///
    func test_subscribe() {
        
        let subscriptionManager: YouEyeTracker.SubscriptionManager<Mock_Subscriber> = .init()
        
        let subscriber1: Mock_Subscriber = .init()
        let subscriber2: Mock_Subscriber = .init()
        let subscriber3: Mock_Subscriber = .init()
        
        // Behavior #1 - 1
            subscriptionManager.subscribe(subscriber1)
            XCTAssertTrue(subscriptionManager.subscribers.contains(where: { $0.subscriber === subscriber1 }))
        
        // Behavior #1 - 2
            subscriptionManager.subscribe(subscriber2)
            XCTAssertTrue(subscriptionManager.subscribers.contains(where: { $0.subscriber === subscriber1 }))
            XCTAssertTrue(subscriptionManager.subscribers.contains(where: { $0.subscriber === subscriber2 }))

        // Behavior #1 - 3
            subscriptionManager.subscribe(subscriber3)
            XCTAssertTrue(subscriptionManager.subscribers.contains(where: { $0.subscriber === subscriber1 }))
            XCTAssertTrue(subscriptionManager.subscribers.contains(where: { $0.subscriber === subscriber2 }))
            XCTAssertTrue(subscriptionManager.subscribers.contains(where: { $0.subscriber === subscriber3 }))
    }
    
    // MARK: - T - Compact
    ///
    /// Tests the function:
    ///
    ///     private func compact()
    ///
    /// The following behavior is expected:
    /// 1. As subscribers are released, compact should remove their wrappers from the subscribers array
    /// 2. As subscribers are retained, it should not
    ///
    func test_compact() {
        
        let subscriptionManager: YouEyeTracker.SubscriptionManager<Mock_Subscriber> = .init()
        
        // Behavior #1 - 1
        
            subscriptionManager.subscribe(Mock_Subscriber())
            subscriptionManager.subscribe(Mock_Subscriber())
            subscriptionManager.subscribe(Mock_Subscriber())
            subscriptionManager.test_compact()
            
            XCTAssertEqual(subscriptionManager.subscribers.count, 0)
        
        // Behavior #2
        
            var subscriber1: Mock_Subscriber! = .init()
            var subscriber2: Mock_Subscriber! = .init()
            var subscriber3: Mock_Subscriber! = .init()
            subscriptionManager.subscribe(subscriber1)
            subscriptionManager.subscribe(subscriber2)
            subscriptionManager.subscribe(subscriber3)
            subscriptionManager.test_compact()
            
            XCTAssertEqual(subscriptionManager.subscribers.count, 3)
        
        // Behavior #1 - 2
        
            subscriber1 = nil
            subscriber2 = nil
            subscriber3 = nil
            subscriptionManager.test_compact()
            
            XCTAssertEqual(subscriptionManager.subscribers.count, 0)
    }
}

// MARK: - Mock Classes

extension SubscriptionManager_Management_Tests {
    
    class Mock_Subscriber {}
}
