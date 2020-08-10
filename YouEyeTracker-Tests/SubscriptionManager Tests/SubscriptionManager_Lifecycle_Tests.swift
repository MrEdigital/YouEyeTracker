///
///  SubscriptionManager_Lifecycle_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// SubscriptionManager Unit Tests - Lifecycle
///
class SubscriptionManager_Lifecycle_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following variables and functions:
///
///     private var subscriptionCleanupTimer: Timer?
///     private let cleanupTimerInterval: TimeInterval
///     deinit
///
extension SubscriptionManager_Lifecycle_Tests {
    
    // MARK: - T - Timer Behavior
    ///
    /// Tests the variables:
    ///
    ///     private var subscriptionCleanupTimer: Timer?
    ///     private let cleanupTimerInterval: TimeInterval
    ///
    /// The following behavior is expected:
    /// 1. Released subscribers should not necessarily be purged immediately
    /// 2. They should, however, be purged within the cleanupTimerInterval
    ///
    func test_timer() {
        
        let subscriptionManager: YouEyeTracker.SubscriptionManager<Mock_Subscriber> = .init()
        
        var subscriber1: Mock_Subscriber! = .init()
        var subscriber2: Mock_Subscriber! = .init()
        var subscriber3: Mock_Subscriber! = .init()
        subscriptionManager.subscribe(subscriber1)
        subscriptionManager.subscribe(subscriber2)
        subscriptionManager.subscribe(subscriber3)
        subscriptionManager.test_compact()
        
        // Pre-Behavior
        
            XCTAssertEqual(subscriptionManager.subscribers.count, 3)

        // Behavior #1
        
            subscriber1 = nil
            subscriber2 = nil
            subscriber3 = nil
        
            XCTAssertEqual(subscriptionManager.subscribers.count, 3)
        
        // Behavior #2
        
            let expectation = self.expectation(description: "Expecting the cleanup timer to reduce the subscriber count to 0 in 10 seconds")
        
            Timer.scheduledTimer(withTimeInterval: subscriptionManager.test_cleanupTimerInterval + 0.5, repeats: false) { _ in
                XCTAssertEqual(subscriptionManager.subscribers.count, 0)
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: subscriptionManager.test_cleanupTimerInterval + 1) { error in
                XCTAssertNil(error)
            }
    }
    
    // MARK: - T - Deinit
    ///
    /// Tests the function:
    ///
    ///     deinit
    ///
    /// The following behavior is expected:
    /// 1. The subscriptionCleanupTimer should be cleared
    /// 2. All subscribers should be removed
    ///
    func test_deinit() {
        
        let subscriptionManager: YouEyeTracker.SubscriptionManager<Mock_Subscriber> = .init()
        
        let subscriber1: Mock_Subscriber! = .init()
        let subscriber2: Mock_Subscriber! = .init()
        let subscriber3: Mock_Subscriber! = .init()
        subscriptionManager.subscribe(subscriber1)
        subscriptionManager.subscribe(subscriber2)
        subscriptionManager.subscribe(subscriber3)
        subscriptionManager.test_compact()
        
        // Pre-Behavior
            XCTAssertEqual(subscriptionManager.subscribers.count, 3)
            XCTAssertNotNil(subscriptionManager.test_subscriptionCleanupTimer)
        
        // Behavior #1
            subscriptionManager.test_onDeinit()
            XCTAssertNil(subscriptionManager.test_subscriptionCleanupTimer)
        
        // Behavior #2
            XCTAssertEqual(subscriptionManager.subscribers.count, 0)
    }
}

// MARK: - Mock Classes

extension SubscriptionManager_Lifecycle_Tests {
    
    class Mock_Subscriber {
        var callCount: Int = 0
        
        func wasCalled() {
            callCount += 1
        }
    }
}
