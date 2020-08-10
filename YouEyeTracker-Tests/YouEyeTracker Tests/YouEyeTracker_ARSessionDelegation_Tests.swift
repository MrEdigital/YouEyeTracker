///
///  YouEyeTracker_ARSessionDelegation_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
import simd
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// YouEyeTracker Unit Tests - ARSession Delegation
///
class YouEyeTracker_ARSessionDelegation_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     public func session(_ session: ARSession, didUpdate anchors: [ARAnchor])
///     public func session(_ session: ARSession, didFailWithError error: Error)
///     func cameraTrackingStateDidChange(to trackingState: ARCamera.TrackingState)
///     func updateFromAnchor(_ faceAnchor: FaceAnchor?)
///     private func resetTracking()
///
extension YouEyeTracker_ARSessionDelegation_Tests {
    
    // MARK: - T - Session Did Update
    ///
    /// Tests the functions:
    ///
    ///     public func session(_ session: ARSession, didUpdate anchors: [ARAnchor])
    ///     func updateFromAnchor(_ faceAnchor: FaceAnchor?)
    ///
    /// The following behavior is expected:
    /// 1. When updateFromAnchor is called with at least one FaceAnchor, eyePositionMovedTo is called on any subscribers
    ///    and updateFromFaceTransform is called on any provided FaceAnchors
    /// 2. When updateFromAnchor is called with no FaceAnchors, no such behavior should occur
    ///
    func test_sessionDidUpdate() {
        
        // Note:  ARAnchors cannot be initialized outside of ARKit, so sessionDidUpdate cannot be called.
        //        Instead, we will test updateFromAnchor, which is the direct result of sessionDidUpdate.
        
        let youEyeTracker: YouEyeTracker = .testInit()
        let faceNode: Mock_ARFaceNode = .init()
        youEyeTracker.test_overrideFaceNode(with: faceNode)
        
        let subscriber: Mock_EyePositionSubscriber! = .init()
        youEyeTracker.subscribe(subscriber)
        
        // Behavior #1 - 1
            youEyeTracker.updateFromAnchor(Mock_FaceAnchor.init())
            XCTAssertEqual(subscriber.callCount_eyePositionMovedTo, 1)
            XCTAssertEqual(faceNode.callCount_updateFromFaceTransform, 1)
        
        // Behavior #2
            youEyeTracker.updateFromAnchor(nil)
            XCTAssertEqual(subscriber.callCount_eyePositionMovedTo, 1)
            XCTAssertEqual(faceNode.callCount_updateFromFaceTransform, 1)
        
        // Behavior #1 - 2
            youEyeTracker.updateFromAnchor(Mock_FaceAnchor.init())
            XCTAssertEqual(subscriber.callCount_eyePositionMovedTo, 2)
            XCTAssertEqual(faceNode.callCount_updateFromFaceTransform, 2)
    }
    
    // MARK: - T - Session Did Fail
    ///
    /// Tests the function:
    ///
    ///     public func session(_ session: ARSession, didFailWithError error: Error)
    ///     private func resetTracking()
    ///
    /// The following behavior is expected:
    /// 1. When a session fails, eyeTrackingInterrupted should be broadcast to any subscribers
    /// 2. resetTracking should then be called, resulting in a newly configured sceneView.session
    ///
    func test_sessionDidFail() {
        
        let youEyeTracker: YouEyeTracker = .testInit()
        let subscriber: Mock_EyePositionSubscriber! = .init()
        youEyeTracker.subscribe(subscriber)
        
        // Pre-Behavior
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 0)
            XCTAssertNil(youEyeTracker.sceneView.session.delegate)
        
        // Behavior #1
            youEyeTracker.session(youEyeTracker.sceneView.session, didFailWithError: Mock_Error.any)
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 1)
        
        // Behavior #2
            XCTAssert(youEyeTracker.sceneView.session.delegate === youEyeTracker)
    }
    
    // MARK: - T - Camera Tracking State Changed
    ///
    /// Tests the function:
    ///
    ///     func cameraTrackingStateDidChange(to trackingState: ARCamera.TrackingState)
    ///
    /// The following behavior is expected:
    /// 1. Unless the trackingState is .notAvailable, nothing should happen
    /// 2. Otherwise, eyeTrackingInterrupted should be broadcast to any subscribers
    ///
    func test_cameraTrackingStateDidChange() {
        
        let youEyeTracker: YouEyeTracker = .testInit()
        let subscriber: Mock_EyePositionSubscriber! = .init()
        youEyeTracker.subscribe(subscriber)
        
        // Pre-Behavior
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 0)
        
        // Behavior #1 - 1
            youEyeTracker.cameraTrackingStateDidChange(to: .normal)
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 0)
        
        // Behavior #2
            youEyeTracker.cameraTrackingStateDidChange(to: .notAvailable)
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 1)
        
        // Behavior #1 - 2
            youEyeTracker.cameraTrackingStateDidChange(to: .normal)
            XCTAssertEqual(subscriber.callCount_eyeTrackingInterrupted, 1)
    }
}

// MARK: - Mock Classes

extension YouEyeTracker_ARSessionDelegation_Tests {
    
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
    
    class Mock_ARFaceNode: YouEyeTracker.ARFaceNode {
        
        var callCount_updateFromFaceTransform: Int = 0
        var callCount_setGeometryInvisible: Int = 0
        var callCount_setGeometryVisible: Int = 0
        
        override func update(fromFaceTransform faceTransform: matrix_float4x4, leftEyeTransform: matrix_float4x4, rightEyeTransform: matrix_float4x4) {
            super.update(fromFaceTransform: faceTransform, leftEyeTransform: leftEyeTransform, rightEyeTransform: rightEyeTransform)
            callCount_updateFromFaceTransform += 1
        }
        
        override func setGeometryVisible(_ visible: Bool) {
            super.setGeometryVisible(visible)
            if visible {
                callCount_setGeometryVisible += 1
            } else {
                callCount_setGeometryInvisible += 1
            }
        }
    }
    
    class Mock_FaceAnchor: FaceAnchor {
        var transform: matrix_float4x4 = .init()
        var leftEyeTransform: matrix_float4x4 = .init()
        var rightEyeTransform: matrix_float4x4 = .init()
    }
    
    enum Mock_Error: Error {
        case any
    }
}
