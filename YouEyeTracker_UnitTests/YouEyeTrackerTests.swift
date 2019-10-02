//
//  YouEyeTrackerTests.swift
//  YouEyeTrackerTests
//
//  Created on 9/28/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

import XCTest
import simd
import SceneKit
import ARKit
@testable import YouEyeTracker

// MARK: - Setup -
class YouEyeTrackerTests : XCTestCase {
    
    class TrackerCallbackTracker: EyePositionSubscriber {
        
        var callCount_eyePositionMovedTo : Int = 0
        var callCount_eyeTrackingInterrupted : Int = 0
        
        func eyePositionMovedTo(xPosition: Float, yPosition: Float, zPosition: Float) {
            callCount_eyePositionMovedTo += 1
        }
        
        func eyeTrackingInterrupted() {
            callCount_eyeTrackingInterrupted += 1
        }
    }
    
    class UpdateTrackingARFaceNode: YouEyeTracker.ARFaceNode {
        
        var callCount_updateFromFaceTransform : Int = 0
        var callCount_setGeometryInvisible : Int = 0
        var callCount_setGeometryVisible : Int = 0
        
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
    
    class FaceAnchorMock: FaceAnchor {
        var transform : matrix_float4x4 = .init()
        var leftEyeTransform : matrix_float4x4 = .init()
        var rightEyeTransform : matrix_float4x4 = .init()
    }
    
    enum MockError: Error {
        case any
    }
    
    var youEyeTracker : YouEyeTracker = .testInit()
    var faceNode : UpdateTrackingARFaceNode = .init()
    
    override func setUp() {
        super.setUp()
        youEyeTracker = .testInit()
        faceNode = .init()
        youEyeTracker.test_overrideFaceNode(with: faceNode)
    }
}

// MARK: - Tests -
extension YouEyeTrackerTests {
    
    func test_configuration() {
        
        YouEyeTracker.configure(with: .init(pointOfView: .leftEye, showTrackingInSceneView: true))
        
        XCTAssertEqual(YouEyeTracker.pointOfView, .leftEye)
        XCTAssertTrue(YouEyeTracker.showTrackingInSceneView)
        
        YouEyeTracker.configure(with: .init(pointOfView: .rightEye, showTrackingInSceneView: false))
        
        XCTAssertEqual(YouEyeTracker.pointOfView, .rightEye)
        XCTAssertFalse(YouEyeTracker.showTrackingInSceneView)
        
        YouEyeTracker.configure(with: .init(pointOfView: .eyeAverage, showTrackingInSceneView: false))
        
        XCTAssertEqual(YouEyeTracker.pointOfView, .eyeAverage)
        XCTAssertFalse(YouEyeTracker.showTrackingInSceneView)
        
        YouEyeTracker.configure(with: .init(pointOfView: nil, showTrackingInSceneView: true))
        
        XCTAssertNil(YouEyeTracker.pointOfView)
        XCTAssertTrue(YouEyeTracker.showTrackingInSceneView)
    }
    
    func test_startStop() {
        
        let tracker1 : TrackerCallbackTracker! = .init()
        youEyeTracker.subscribe(tracker1)
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 0)
        XCTAssertNil(youEyeTracker.sceneView.session.delegate)
        
        youEyeTracker.start()
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 0)
        XCTAssertNotNil(youEyeTracker.sceneView.session.delegate)
        
        youEyeTracker.stop()
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 1)
        XCTAssertNil(youEyeTracker.sceneView.session.delegate)
        
        youEyeTracker.start()
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 1)
        
        youEyeTracker.stop()
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 2)
    }
    
    func test_broadcastEyePositionMoved() {
        
        let tracker1 : TrackerCallbackTracker! = .init()
        youEyeTracker.subscribe(tracker1)
        XCTAssertEqual(tracker1.callCount_eyePositionMovedTo, 0)
        
        youEyeTracker.test_broadcastEyePositionMoved(to: .init(1,2,3))
        XCTAssertEqual(tracker1.callCount_eyePositionMovedTo, 1)
        
        youEyeTracker.test_broadcastEyePositionMoved(to: .init(2,3,4))
        XCTAssertEqual(tracker1.callCount_eyePositionMovedTo, 2)
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 0)
        
        youEyeTracker.test_broadcastEyePositionMoved(to: nil)
        XCTAssertEqual(tracker1.callCount_eyePositionMovedTo, 2)
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 1)
    }
    
    func test_broadcastEyeTrackingInerruption() {
        
        let tracker1 : TrackerCallbackTracker! = .init()
        youEyeTracker.subscribe(tracker1)
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 0)
        
        youEyeTracker.test_broadcastEyeTrackingInerruption()
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 1)
        
        youEyeTracker.test_broadcastEyeTrackingInerruption()
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 2)
    }
    
    func test_geometryVisibility() {
        
        XCTAssertEqual(faceNode.callCount_setGeometryVisible, 0)
        XCTAssertEqual(faceNode.callCount_setGeometryInvisible, 0)
        
        youEyeTracker.setGeometryVisible(true)
        XCTAssertEqual(faceNode.callCount_setGeometryVisible, 1)
        XCTAssertEqual(faceNode.callCount_setGeometryInvisible, 0)
        
        youEyeTracker.setGeometryVisible(false)
        XCTAssertEqual(faceNode.callCount_setGeometryVisible, 1)
        XCTAssertEqual(faceNode.callCount_setGeometryInvisible, 1)
        
        youEyeTracker.setGeometryVisible(true)
        XCTAssertEqual(faceNode.callCount_setGeometryVisible, 2)
        XCTAssertEqual(faceNode.callCount_setGeometryInvisible, 1)
    }
}

extension YouEyeTrackerTests {
    
    func test_sessionDidUpdate() {
        
        let tracker1 : TrackerCallbackTracker! = .init()
        youEyeTracker.subscribe(tracker1)
        
        youEyeTracker.updateFromAnchor(FaceAnchorMock.init())
        
        XCTAssertEqual(tracker1.callCount_eyePositionMovedTo, 1)
        XCTAssertEqual(faceNode.callCount_updateFromFaceTransform, 1)
        
        youEyeTracker.updateFromAnchor(nil)
        
        XCTAssertEqual(tracker1.callCount_eyePositionMovedTo, 1)
        XCTAssertEqual(faceNode.callCount_updateFromFaceTransform, 1)
        
        youEyeTracker.updateFromAnchor(FaceAnchorMock.init())
        
        XCTAssertEqual(tracker1.callCount_eyePositionMovedTo, 2)
        XCTAssertEqual(faceNode.callCount_updateFromFaceTransform, 2)
    }
    
    func test_sessionUnavailable() {
        
        let tracker1 : TrackerCallbackTracker! = .init()
        youEyeTracker.subscribe(tracker1)
        
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 0)
        
        youEyeTracker.cameraTrackingStateDidChange(to: .normal)
        
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 0)
        
        youEyeTracker.cameraTrackingStateDidChange(to: .notAvailable)
        
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 1)
        
        youEyeTracker.cameraTrackingStateDidChange(to: .normal)
        
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 1)
    }
    
    func test_sessionFailure() {
        
        let tracker1 : TrackerCallbackTracker! = .init()
        youEyeTracker.subscribe(tracker1)
        
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 0)
        
        youEyeTracker.session(youEyeTracker.sceneView.session, didFailWithError: MockError.any)
        
        XCTAssertEqual(tracker1.callCount_eyeTrackingInterrupted, 1)
        XCTAssertNotNil(youEyeTracker.sceneView.session.delegate)
    }
}
