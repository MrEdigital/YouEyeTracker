///
///  YouEyeTracker_DebuggingAndDemo_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
import simd
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// YouEyeTracker Unit Tests - Debugging / Demonstration
///
class YouEyeTracker_DebuggingAndDemo_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func setGeometryVisible(_ geometryVisible: Bool)
///
extension YouEyeTracker_DebuggingAndDemo_Tests {
    
    // MARK: - T - Set Geometry Visible
    ///
    /// Tests the function:
    ///
    ///     func setGeometryVisible(_ geometryVisible: Bool)
    ///
    /// The following behavior is expected:
    /// 1. If set to true, it's faceNode's setGeometryVisible(_: Bool) should be called with true
    /// 2. If set to false, it's faceNode's setGeometryVisible(_: Bool) should be called with false
    ///
    func test_setGeometryVisible() {
        
        let youEyeTracker: YouEyeTracker = .testInit()
        let faceNode: Mock_ARFaceNode = .init()
        youEyeTracker.test_overrideFaceNode(with: faceNode)
        
        // Pre-Behavior
            XCTAssertEqual(faceNode.callCount_setGeometryVisible, 0)
            XCTAssertEqual(faceNode.callCount_setGeometryInvisible, 0)
        
        // Behavior #1 - 1
            youEyeTracker.setGeometryVisible(true)
            XCTAssertEqual(faceNode.callCount_setGeometryVisible, 1)
            XCTAssertEqual(faceNode.callCount_setGeometryInvisible, 0)
        
        // Behavior #2
            youEyeTracker.setGeometryVisible(false)
            XCTAssertEqual(faceNode.callCount_setGeometryVisible, 1)
            XCTAssertEqual(faceNode.callCount_setGeometryInvisible, 1)
        
        // Behavior #1 - 2
            youEyeTracker.setGeometryVisible(true)
            XCTAssertEqual(faceNode.callCount_setGeometryVisible, 2)
            XCTAssertEqual(faceNode.callCount_setGeometryInvisible, 1)
    }
}

// MARK: - Mock Classes

extension YouEyeTracker_DebuggingAndDemo_Tests {
    
    class Mock_ARFaceNode: YouEyeTracker.ARFaceNode {
        
        var callCount_setGeometryInvisible: Int = 0
        var callCount_setGeometryVisible: Int = 0
        
        override func setGeometryVisible(_ visible: Bool) {
            super.setGeometryVisible(visible)
            if visible {
                callCount_setGeometryVisible += 1
            } else {
                callCount_setGeometryInvisible += 1
            }
        }
        
        // unused
        override func update(fromFaceTransform faceTransform: matrix_float4x4, leftEyeTransform: matrix_float4x4, rightEyeTransform: matrix_float4x4) {}
    }
}
