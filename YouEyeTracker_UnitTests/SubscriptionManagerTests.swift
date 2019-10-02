//
//  SubscriptionManagerTests.swift
//  YouEyeTrackerTests
//
//  Created on 9/28/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

import XCTest
@testable import YouEyeTracker

class SubscriptionManagerTests: XCTestCase {
    
    class SubscriptionCallbackTracker {
        var callCount: Int = 0
        
        func wasCalled() {
            callCount += 1
        }
    }
    
    func test_compact() {
        
        let subscriptionManager: YouEyeTracker.SubscriptionManager<SubscriptionCallbackTracker> = .init()
        
        subscriptionManager.subscribe(SubscriptionCallbackTracker())
        subscriptionManager.subscribe(SubscriptionCallbackTracker())
        subscriptionManager.subscribe(SubscriptionCallbackTracker())
        subscriptionManager.test_compact()
        
        XCTAssertEqual(subscriptionManager.subscribers.count, 0)
        
        var tracker1: SubscriptionCallbackTracker! = .init()
        var tracker2: SubscriptionCallbackTracker! = .init()
        var tracker3: SubscriptionCallbackTracker! = .init()
        subscriptionManager.subscribe(tracker1)
        subscriptionManager.subscribe(tracker2)
        subscriptionManager.subscribe(tracker3)
        subscriptionManager.test_compact()
        
        XCTAssertEqual(subscriptionManager.subscribers.count, 3)
        
        tracker1 = nil
        tracker2 = nil
        tracker3 = nil
        subscriptionManager.test_compact()
        
        XCTAssertEqual(subscriptionManager.subscribers.count, 0)
    }
    
    func test_usage() {
        
        let subscriptionManager: YouEyeTracker.SubscriptionManager<SubscriptionCallbackTracker> = .init()
        
        let tracker1: SubscriptionCallbackTracker! = .init()
        let tracker2: SubscriptionCallbackTracker! = .init()
        let tracker3: SubscriptionCallbackTracker! = .init()
        
        subscriptionManager.subscribe(tracker1)
        subscriptionManager.subscribers.forEach { $0.subscriber?.wasCalled() }
        
        subscriptionManager.subscribe(tracker2)
        subscriptionManager.subscribers.forEach { $0.subscriber?.wasCalled() }
        
        subscriptionManager.subscribe(tracker3)
        subscriptionManager.subscribers.forEach { $0.subscriber?.wasCalled() }
        
        XCTAssertEqual(tracker1.callCount, 3)
        XCTAssertEqual(tracker2.callCount, 2)
        XCTAssertEqual(tracker3.callCount, 1)
    }
    
    func test_timer() {
        
        let subscriptionManager: YouEyeTracker.SubscriptionManager<SubscriptionCallbackTracker> = .init()
        
        var tracker1: SubscriptionCallbackTracker! = .init()
        var tracker2: SubscriptionCallbackTracker! = .init()
        var tracker3: SubscriptionCallbackTracker! = .init()
        subscriptionManager.subscribe(tracker1)
        subscriptionManager.subscribe(tracker2)
        subscriptionManager.subscribe(tracker3)
        subscriptionManager.test_compact()
        
        XCTAssertEqual(subscriptionManager.subscribers.count, 3)
        
        tracker1 = nil
        tracker2 = nil
        tracker3 = nil
        
        let expectation = self.expectation(description: "Expecting the cleanup timer to reduce the subscriber count to 0 in 10 seconds")
        
        Timer.scheduledTimer(withTimeInterval: subscriptionManager.cleanupTimerInterval + 0.5, repeats: false) { _ in
            XCTAssertEqual(subscriptionManager.subscribers.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: subscriptionManager.cleanupTimerInterval + 1) { error in
            XCTAssertNil(error)
        }
    }
    
    func test_deinit() {
        
        let subscriptionManager: YouEyeTracker.SubscriptionManager<SubscriptionCallbackTracker> = .init()
        
        let tracker1: SubscriptionCallbackTracker! = .init()
        let tracker2: SubscriptionCallbackTracker! = .init()
        let tracker3: SubscriptionCallbackTracker! = .init()
        subscriptionManager.subscribe(tracker1)
        subscriptionManager.subscribe(tracker2)
        subscriptionManager.subscribe(tracker3)
        subscriptionManager.test_compact()
        
        XCTAssertEqual(subscriptionManager.subscribers.count, 3)
        XCTAssertNotNil(subscriptionManager.test_subscriptionCleanupTimer)
        
        subscriptionManager.test_onDeinit()
        
        XCTAssertEqual(subscriptionManager.subscribers.count, 0)
        XCTAssertNil(subscriptionManager.test_subscriptionCleanupTimer)
    }
}
