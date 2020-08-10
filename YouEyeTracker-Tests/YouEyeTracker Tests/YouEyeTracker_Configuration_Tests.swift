///
///  YouEyeTracker_Configuration_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// YouEyeTracker Unit Tests - Configuration
///
class YouEyeTracker_Configuration_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     public func configure(with configuration: YouEyeTracker.Config)
///
extension YouEyeTracker_Configuration_Tests {
    
    // MARK: - T - Configure With ...
    ///
    /// Tests the function:
    ///
    ///     public func configure(with configuration: YouEyeTracker.Config)
    ///
    /// The following behavior is expected:
    /// 1. The tracker's pointOfView should match the provided configuration's pointOfView
    ///    The tracker's showTrackingInSceneView should match the provided configuration's showTrackingInSceneView
    ///
    func test_configuration() {
        
        let youEyeTracker: YouEyeTracker = .testInit()
        
        // Behavior #1 - 1
            youEyeTracker.configure(with: .init(pointOfView: .leftEye, showTrackingInSceneView: true))
            
            XCTAssertEqual(youEyeTracker.test_pointOfView, .leftEye)
            XCTAssertTrue(youEyeTracker.test_showTrackingInSceneView)
        
        // Behavior #1 - 2
            youEyeTracker.configure(with: .init(pointOfView: .rightEye, showTrackingInSceneView: false))
            
            XCTAssertEqual(youEyeTracker.test_pointOfView, .rightEye)
            XCTAssertFalse(youEyeTracker.test_showTrackingInSceneView)
        
        // Behavior #1 - 3
            youEyeTracker.configure(with: .init(pointOfView: .eyeAverage, showTrackingInSceneView: false))
            
            XCTAssertEqual(youEyeTracker.test_pointOfView, .eyeAverage)
            XCTAssertFalse(youEyeTracker.test_showTrackingInSceneView)
        
        // Behavior #1 - 4
            youEyeTracker.configure(with: .init(pointOfView: nil, showTrackingInSceneView: true))
            
            XCTAssertNil(youEyeTracker.test_pointOfView)
            XCTAssertTrue(youEyeTracker.test_showTrackingInSceneView)
    }
}
