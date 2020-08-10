///
///  ARFaceNode_Behavior_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
import simd
import SceneKit
import ARKit
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// ARFaceNode Unit Tests - Behavior
///
class ARFaceNode_Behavior_Tests: XCTestCase {
    
    typealias ARFaceNode = YouEyeTracker.ARFaceNode
    var faceNode: ARFaceNode = .init()
    
    override func setUp() {
        super.setUp()
        faceNode = .init()
    }
    
    // TODO: Fill these in with reliable test values.
    //       No, really.  Try not to forget to do this at some point.  (narrator:  He did.)
    static let transformTests: [Mock_Transform] = [.init(faceTransform:       .init(.init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0)),
                                                         leftEyeTransform:    .init(.init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0)),
                                                         rightEyeTransform:   .init(.init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0)),
                                                         position:            .init(0, 0, 0),
                                                         leftEyePosition:     .init(0, 0, 0),
                                                         rightEyePosition:    .init(0, 0, 0))]
    
    static let eyePositionTests: [Mock_EyePosition] = [.init(leftEyePosition: .init(-1,-2,-3),               rightEyePosition: .init(2,4,6),                 pointOfView: .leftEye,    expectedResult: .init(-1,-2,-3)),
                                                       .init(leftEyePosition: .init(16,-22,-43),             rightEyePosition: .init(2,4,6),                 pointOfView: .leftEye,    expectedResult: .init(16,-22,-43)),
                                                       .init(leftEyePosition: .init(-267.3,-247.11,-3.255),  rightEyePosition: .init(2.664,424.24,-6.245),   pointOfView: .leftEye,    expectedResult: .init(-267.3,-247.11,-3.255)),
                                                       .init(leftEyePosition: .init(-1,-2,-3),               rightEyePosition: .init(2,4,6),                 pointOfView: .rightEye,   expectedResult: .init(2,4,6)),
                                                       .init(leftEyePosition: .init(16,-22,-43),             rightEyePosition: .init(2,4,6),                 pointOfView: .rightEye,   expectedResult: .init(2,4,6)),
                                                       .init(leftEyePosition: .init(-267.3,-247.11,-3.255),  rightEyePosition: .init(2.664,424.24,-6.245),   pointOfView: .rightEye,   expectedResult: .init(2.664,424.24,-6.245)),
                                                       .init(leftEyePosition: .init(-1,-2,-3),               rightEyePosition: .init(2,4,6),                 pointOfView: .eyeAverage, expectedResult: .init(0.5,1.0,1.5)),
                                                       .init(leftEyePosition: .init(16,-22,-43),             rightEyePosition: .init(2,4,6),                 pointOfView: .eyeAverage, expectedResult: .init(9,-9,-18.5)),
                                                       .init(leftEyePosition: .init(-267.3,-247.11,-3.255),  rightEyePosition: .init(2.664,424.24,-6.245),   pointOfView: .eyeAverage, expectedResult: .init(-132.318,88.56499,-4.75))]
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func update(fromFaceTransform faceTransform: matrix_float4x4, leftEyeTransform: matrix_float4x4, rightEyeTransform: matrix_float4x4)
///     func eyePosition(for pointOfView: YouEyeTracker.Config.PointOfView?) -> SCNVector3
///     func eyeProjectionPosition(for pointOfView: YouEyeTracker.Config.PointOfView) -> SCNVector3
///     func setGeometryVisible(_ geometryVisible: Bool)
///
extension ARFaceNode_Behavior_Tests {
    
    // MARK: - T - Update from Face Transform
    ///
    /// Tests the function:
    ///
    ///     func update(fromFaceTransform faceTransform: matrix_float4x4, leftEyeTransform: matrix_float4x4, rightEyeTransform: matrix_float4x4)
    ///
    /// The following behavior is expected:
    /// 1. The simdTransform of the faceNode should match the provided faceTransform value
    /// 2. The simdTransform of the faceNode's left and right eye node should each match their respective transform values
    ///
    func test_updateFromFaceTransform() {
        
        for transformTest in Self.transformTests {
            faceNode.update(fromFaceTransform: transformTest.faceTransform, leftEyeTransform: transformTest.leftEyeTransform, rightEyeTransform: transformTest.rightEyeTransform)
            
            // Behavior #1
                XCTAssertEqual(faceNode.simdTransform, transformTest.faceTransform)
            
            // Behavior #2
                XCTAssertEqual(faceNode.test_leftEyeNode.simdTransform, transformTest.leftEyeTransform)
                XCTAssertEqual(faceNode.test_rightEyeNode.simdTransform, transformTest.rightEyeTransform)
        }
    }
    
    // MARK: - T - Eye Position For POV
    ///
    /// Tests the function:
    ///
    ///     func eyePosition(for pointOfView: YouEyeTracker.Config.PointOfView?) -> SCNVector3
    ///
    /// The following behavior is expected:
    /// 1. A null pointOfView should return SCNVector3Zero
    /// 2. .leftEye pointOfView should return leftEyeNode.worldPosition,
    ///    .rightEye pointOfView should return rightEyeNode.worldPosition,
    ///    .eyeAverage pointOfView should return the averaged value of each
    ///
    func test_eyePosition() {
        
        // Behavior #1
            XCTAssertTrue(SCNVector3EqualToVector3(faceNode.eyePosition(for: nil), SCNVector3Zero))
        
        for eyePositionTest in Self.eyePositionTests {
            
            // Behavior #2
                faceNode.test_leftEyeNode.position = eyePositionTest.leftEyePosition
                faceNode.test_rightEyeNode.position = eyePositionTest.rightEyePosition
                print("Position: \(faceNode.eyePosition(for: eyePositionTest.pointOfView)), expected: \(eyePositionTest.expectedResult)")
                XCTAssertTrue(SCNVector3EqualToVector3(faceNode.eyePosition(for: eyePositionTest.pointOfView), eyePositionTest.expectedResult))
        }
    }
    
    // MARK: - T - Eye Projection Position
    ///
    /// Tests the function:
    ///
    ///     func eyeProjectionPosition(for pointOfView: YouEyeTracker.Config.PointOfView) -> SCNVector3
    ///
    /// The following behavior is expected:
    /// 1. .leftEye pointOfView should return leftEyeProjectionNode.worldPosition,
    ///    .rightEye pointOfView should return rightEyeProjectionNode.worldPosition,
    ///    .eyeAverage pointOfView should return the averaged value of each
    ///
    func test_eyeProjectionPosition() {
        
        for eyePositionTest in Self.eyePositionTests {
            
            // Behavior #1
            
                faceNode.test_leftEyeNode.position = eyePositionTest.leftEyePosition
                faceNode.test_rightEyeNode.position = eyePositionTest.rightEyePosition
                print("Position: \(faceNode.eyePosition(for: eyePositionTest.pointOfView)), expected: \(eyePositionTest.expectedResult)")
                
                let projectionPosition: SCNVector3 = faceNode.eyeProjectionPosition(for: eyePositionTest.pointOfView)
                var expectedPosition: SCNVector3 = eyePositionTest.expectedResult
                expectedPosition.x += faceNode.test_leftEyeProjectionNode.position.x
                expectedPosition.y += faceNode.test_leftEyeProjectionNode.position.y
                expectedPosition.z += faceNode.test_leftEyeProjectionNode.position.z
                
                XCTAssertTrue(SCNVector3EqualToVector3(projectionPosition, expectedPosition))
        }
    }
    
    // MARK: - T - Set Geometry Visible
    /// Tests the function:
    ///
    ///     func setGeometryVisible(_ geometryVisible: Bool)
    ///
    /// The following behavior is expected:
    /// 1. If true, geometry should be created for the faceNode, left/rightEyeNode, and left/rightEyeProjectionNode.
    ///    Additionally, their diffuse contents should each be set.
    /// 2. If false, all mentioned geometries should be nil'ed
    ///
    func test_setGeometryVisible() {
        
        // Pre-Behavior
            XCTAssertNil(faceNode.geometry)
            XCTAssertNil(faceNode.test_leftEyeNode.geometry)
            XCTAssertNil(faceNode.test_rightEyeNode.geometry)
            XCTAssertNil(faceNode.test_leftEyeProjectionNode.geometry)
            XCTAssertNil(faceNode.test_rightEyeProjectionNode.geometry)
        
        // Behavior #1 - 1
            faceNode.setGeometryVisible(true)
            
            XCTAssertNotNil(faceNode.geometry)
            XCTAssertNotNil(faceNode.test_leftEyeNode.geometry)
            XCTAssertNotNil(faceNode.test_rightEyeNode.geometry)
            XCTAssertNotNil(faceNode.test_leftEyeProjectionNode.geometry)
            XCTAssertNotNil(faceNode.test_rightEyeProjectionNode.geometry)
            XCTAssertNotNil(faceNode.geometry?.firstMaterial?.diffuse.contents)
            XCTAssertNotNil(faceNode.test_leftEyeNode.geometry?.firstMaterial?.diffuse.contents)
            XCTAssertNotNil(faceNode.test_rightEyeNode.geometry?.firstMaterial?.diffuse.contents)
            XCTAssertNotNil(faceNode.test_leftEyeProjectionNode.geometry?.firstMaterial?.diffuse.contents)
            XCTAssertNotNil(faceNode.test_rightEyeProjectionNode.geometry?.firstMaterial?.diffuse.contents)
        
        // Behavior #2
            faceNode.setGeometryVisible(false)
            
            XCTAssertNil(faceNode.geometry)
            XCTAssertNil(faceNode.test_leftEyeNode.geometry)
            XCTAssertNil(faceNode.test_rightEyeNode.geometry)
            XCTAssertNil(faceNode.test_leftEyeProjectionNode.geometry)
            XCTAssertNil(faceNode.test_rightEyeProjectionNode.geometry)
        
        // Behavior #1 - 2
            faceNode.setGeometryVisible(true)
            
            XCTAssertNotNil(faceNode.geometry)
            XCTAssertNotNil(faceNode.test_leftEyeNode.geometry)
            XCTAssertNotNil(faceNode.test_rightEyeNode.geometry)
            XCTAssertNotNil(faceNode.test_leftEyeProjectionNode.geometry)
            XCTAssertNotNil(faceNode.test_rightEyeProjectionNode.geometry)
            XCTAssertNotNil(faceNode.geometry?.firstMaterial?.diffuse.contents)
            XCTAssertNotNil(faceNode.test_leftEyeNode.geometry?.firstMaterial?.diffuse.contents)
            XCTAssertNotNil(faceNode.test_rightEyeNode.geometry?.firstMaterial?.diffuse.contents)
            XCTAssertNotNil(faceNode.test_leftEyeProjectionNode.geometry?.firstMaterial?.diffuse.contents)
            XCTAssertNotNil(faceNode.test_rightEyeProjectionNode.geometry?.firstMaterial?.diffuse.contents)
    }
}

// MARK: - Mock Classes

extension ARFaceNode_Behavior_Tests {
    
    struct Mock_Transform {
        let faceTransform: simd_float4x4
        let leftEyeTransform: simd_float4x4
        let rightEyeTransform: simd_float4x4
        let position: SCNVector3
        let leftEyePosition: SCNVector3
        let rightEyePosition: SCNVector3
    }
    
    struct Mock_EyePosition {
        let leftEyePosition: SCNVector3
        let rightEyePosition: SCNVector3
        let pointOfView: YouEyeTracker.Config.PointOfView
        let expectedResult: SCNVector3
    }
}
