///
///  YouEyeTracker_StartingStopping_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// YouEyeTracker Unit Tests - Starting and Stopping
///
class YouEyeTracker_StartingStopping_Tests: XCTestCase {
    
    var youEyeTracker : YouEyeTracker = .testInit()
    
    override func setUp() {
        super.setUp()
        youEyeTracker = .testInit()
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     public func start()
///     public func stop()
///
extension YouEyeTracker_StartingStopping_Tests {
    
    // MARK: - T - Start / Stop
    ///
    /// Tests the functions:
    ///
    ///     public func start()
    ///     public func stop()
    ///
    /// The following behavior is expected:
    /// 1. On start, the tracker's sceneView's session's delegate should be set
    /// 2. On stop, said delegate should be nil'ed, and eyeTrackingInterrupted() should be called
    ///
    func test_startStop() {
        
        // Pre-Behavior
            let tracker1 : Mock_EyePositionSubscriber! = .init()
            youEyeTracker.subscribe(tracker1)
            XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 0)
            XCTAssertNil(youEyeTracker.sceneView.session.delegate)
        
        // Behavior #1 - 1
            youEyeTracker.start()
            XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 0)
            XCTAssertNotNil(youEyeTracker.sceneView.session.delegate)
        
        // Behavior #2 - 1
            youEyeTracker.stop()
            XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 1)
            XCTAssertNil(youEyeTracker.sceneView.session.delegate)
        
        // Behavior #1 - 2
            youEyeTracker.start()
            XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 1)
        
        // Behavior #2 - 2
            youEyeTracker.stop()
            XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 2)
    }
}

// MARK: - Mock Classes

extension YouEyeTracker_StartingStopping_Tests {
    
    class Mock_EyePositionSubscriber: EyePositionSubscriber {
        
        var callCount_eyeTrackingInterrupted: Int = 0
        func eyeTrackingInterrupted() {
            callCount_eyeTrackingInterrupted += 1
        }
        
        // Unused
        func eyePositionMovedTo(xPosition: Float, yPosition: Float, zPosition: Float) { }
    }
}

