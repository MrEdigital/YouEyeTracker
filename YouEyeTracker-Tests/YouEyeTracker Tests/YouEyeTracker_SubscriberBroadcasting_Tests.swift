///
///  YouEyeTracker_SubscriberBroadcasting_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// YouEyeTracker Unit Tests - Subscriber Broadcasting
///
class YouEyeTracker_SubscriberBroadcasting_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     private func broadcastEyePositionMoved(to position: SIMD3<Float>?)
///     private func broadcastEyeTrackingInerruption()
///
extension YouEyeTracker_SubscriberBroadcasting_Tests {
    
    // MARK: - T - Broadcast Eye Position Moved
    ///
    /// Tests the function:
    ///
    ///     private func broadcastEyePositionMoved(to position: SIMD3<Float>?)
    ///
    /// The following behavior is expected:
    /// 1. On some broadcast, eyePositionMovedTo(...) should be called
    /// 2. On nil broadcast, eyeTrackingInterrupted() should be called
    ///
    func test_broadcastEyePositionMoved() {
        
        let youEyeTracker: YouEyeTracker = .testInit()
        
        // Pre-Behavior
            let subscriber: Mock_EyePositionSubscriber! = .init()
            youEyeTracker.subscribe(subscriber)
            XCTAssertEqual(subscriber.callCount_eyePositionMovedTo, 0)
        
        // Behavior #1 - 1
            youEyeTracker.test_broadcastEyePositionMoved(to: .init(1,2,3))
            XCTAssertEqual(subscriber.callCount_eyePositionMovedTo, 1)
        
        // Behavior #1 - 2
            youEyeTracker.test_broadcastEyePositionMoved(to: .init(2,3,4))
            XCTAssertEqual(subscriber.callCount_eyePositionMovedTo, 2)
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 0)
        
        // Behavior #2
            youEyeTracker.test_broadcastEyePositionMoved(to: nil)
            XCTAssertEqual(subscriber.callCount_eyePositionMovedTo, 2)
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 1)
    }
    
    // MARK: - T - Broadcast Eye Tracking Interruption
    ///
    /// Tests the function:
    ///
    ///     private func broadcastEyeTrackingInerruption()
    ///
    /// The following behavior is expected:
    /// 1. On broadcast, eyeTrackingInterrupted() should be called
    ///
    func test_broadcastEyeTrackingInerruption() {
        
        let youEyeTracker: YouEyeTracker = .testInit()
        
        // Pre-Behavior
            let subscriber: Mock_EyePositionSubscriber! = .init()
            youEyeTracker.subscribe(subscriber)
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 0)
        
        // Behavior #1 - 1
            youEyeTracker.test_broadcastEyeTrackingInerruption()
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 1)
        
        // Behavior #1 - 2
            youEyeTracker.test_broadcastEyeTrackingInerruption()
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 2)
    }
}

// MARK: - Mock Classes

extension YouEyeTracker_SubscriberBroadcasting_Tests {
    
    class Mock_EyePositionSubscriber: EyePositionSubscriber {
        
        var callCount_eyePositionMovedTo: Int = 0
        var callCount_eyeTrackingInterrupted: Int = 0
        
        func eyePositionMovedTo(xPosition: Float, yPosition: Float, zPosition: Float) {
            callCount_eyePositionMovedTo += 1
        }
        
        func eyeTrackingInterrupted() {
            callCount_eyeTrackingInterrupted += 1
        }
    }
}
