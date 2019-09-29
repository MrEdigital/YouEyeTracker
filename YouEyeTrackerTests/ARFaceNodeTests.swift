//
//  ARFaceNodeTests.swift
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
class ARFaceNodeTests : XCTestCase {
    typealias ARFaceNode = YouEyeTracker.ARFaceNode
    var faceNode: ARFaceNode = .init()
    
    override func setUp() {
        super.setUp()
        faceNode = .init()
    }
    
    struct TransformTest {
        let faceTransform : simd_float4x4
        let leftEyeTransform : simd_float4x4
        let rightEyeTransform : simd_float4x4
        let position : SCNVector3
        let leftEyePosition : SCNVector3
        let rightEyePosition : SCNVector3
    }
    
    struct EyePositionTest {
        let leftEyePosition : SCNVector3
        let rightEyePosition : SCNVector3
        let pointOfView : YouEyeTracker.Config.PointOfView
        let expectedResult : SCNVector3
    }
    
    // TODO: Fill these in with reliable test values
    static let transformTests: [TransformTest] = [.init(faceTransform:       .init(.init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0)),
                                                        leftEyeTransform:    .init(.init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0)),
                                                        rightEyeTransform:   .init(.init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0), .init(0,0,0,0)),
                                                        position:            .init(0, 0, 0),
                                                        leftEyePosition:     .init(0, 0, 0),
                                                        rightEyePosition:    .init(0, 0, 0))]
    
    static let eyePositionTests: [EyePositionTest] = [.init(leftEyePosition: .init(-1,-2,-3),               rightEyePosition: .init(2,4,6),                 pointOfView: .leftEye,    expectedResult: .init(-1,-2,-3)),
                                                      .init(leftEyePosition: .init(16,-22,-43),             rightEyePosition: .init(2,4,6),                 pointOfView: .leftEye,    expectedResult: .init(16,-22,-43)),
                                                      .init(leftEyePosition: .init(-267.3,-247.11,-3.255),  rightEyePosition: .init(2.664,424.24,-6.245),   pointOfView: .leftEye,    expectedResult: .init(-267.3,-247.11,-3.255)),
                                                      .init(leftEyePosition: .init(-1,-2,-3),               rightEyePosition: .init(2,4,6),                 pointOfView: .rightEye,   expectedResult: .init(2,4,6)),
                                                      .init(leftEyePosition: .init(16,-22,-43),             rightEyePosition: .init(2,4,6),                 pointOfView: .rightEye,   expectedResult: .init(2,4,6)),
                                                      .init(leftEyePosition: .init(-267.3,-247.11,-3.255),  rightEyePosition: .init(2.664,424.24,-6.245),   pointOfView: .rightEye,   expectedResult: .init(2.664,424.24,-6.245)),
                                                      .init(leftEyePosition: .init(-1,-2,-3),               rightEyePosition: .init(2,4,6),                 pointOfView: .eyeAverage, expectedResult: .init(0.5,1.0,1.5)),
                                                      .init(leftEyePosition: .init(16,-22,-43),             rightEyePosition: .init(2,4,6),                 pointOfView: .eyeAverage, expectedResult: .init(9,-9,-18.5)),
                                                      .init(leftEyePosition: .init(-267.3,-247.11,-3.255),  rightEyePosition: .init(2.664,424.24,-6.245),   pointOfView: .eyeAverage, expectedResult: .init(-132.318,88.56499,-4.75))]
}

// MARK: - Tests -
extension ARFaceNodeTests {
    
    class Coder: NSCoder {
        override var allowsKeyedCoding: Bool { return true }
        override func decodeObject(forKey key: String) -> Any? { return nil }
        override func containsValue(forKey key: String) -> Bool { return false }
        override func decodeInteger(forKey key: String) -> Int { return 0 }
        override func decodeCInt(forKey key: String) -> Int32 { return 0 }
        override func decodeInt32(forKey key: String) -> Int32 { return 0 }
        override func decodeInt64(forKey key: String) -> Int64 { return 0 }
        override func decodeFloat(forKey key: String) -> Float { return 0 }
        override func decodeBool(forKey key: String) -> Bool { return false }
        override func decodeBytes(forKey key: String, returnedLength lengthp: UnsafeMutablePointer<Int>?) -> UnsafePointer<UInt8>? { return nil
        }
    }
    
    func test_decodability() {
        
        let faceNode = ARFaceNode.init(coder: Coder())
        
        // I don't care for restorability in this case, so this is simply a test to ensure it hits setup() via init?(coder aDecoder:)
        XCTAssertNotNil(faceNode?.test_leftEyeNode.parent)
        XCTAssertNotNil(faceNode?.test_rightEyeNode.parent)
        XCTAssertNotNil(faceNode?.test_leftEyeProjectionNode.parent)
        XCTAssertNotNil(faceNode?.test_rightEyeProjectionNode.parent)
    }
    
    func test_updateFromAnchor() {
        
        for transformTest in ARFaceNodeTests.transformTests {
            faceNode.update(fromFaceTransform: transformTest.faceTransform, leftEyeTransform: transformTest.rightEyeTransform, rightEyeTransform: transformTest.rightEyeTransform)
            XCTAssertTrue(SCNVector3EqualToVector3(faceNode.worldPosition, transformTest.position))
            XCTAssertTrue(SCNVector3EqualToVector3(faceNode.test_leftEyeNode.worldPosition, transformTest.leftEyePosition))
            XCTAssertTrue(SCNVector3EqualToVector3(faceNode.test_rightEyeNode.worldPosition, transformTest.rightEyePosition))
        }
    }
    
    func test_eyePosition() {
        
        for eyePositionTest in ARFaceNodeTests.eyePositionTests {
            faceNode.test_leftEyeNode.position = eyePositionTest.leftEyePosition
            faceNode.test_rightEyeNode.position = eyePositionTest.rightEyePosition
            print("Position: \(faceNode.eyePosition(for: eyePositionTest.pointOfView)), expected: \(eyePositionTest.expectedResult)")
            XCTAssertTrue(SCNVector3EqualToVector3(faceNode.eyePosition(for: eyePositionTest.pointOfView), eyePositionTest.expectedResult))
        }
    }
    
    func test_eyeProjectionPosition() {
        
        for eyePositionTest in ARFaceNodeTests.eyePositionTests {
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
    
    func test_setGeometryVisible() {
        
        XCTAssertNil(faceNode.geometry)
        XCTAssertNil(faceNode.test_leftEyeNode.geometry)
        XCTAssertNil(faceNode.test_rightEyeNode.geometry)
        XCTAssertNil(faceNode.test_leftEyeProjectionNode.geometry)
        XCTAssertNil(faceNode.test_rightEyeProjectionNode.geometry)
        
        faceNode.setGeometryVisible(true)
        
        XCTAssertNotNil(faceNode.geometry)
        XCTAssertNotNil(faceNode.test_leftEyeNode.geometry)
        XCTAssertNotNil(faceNode.test_rightEyeNode.geometry)
        XCTAssertNotNil(faceNode.test_leftEyeProjectionNode.geometry)
        XCTAssertNotNil(faceNode.test_rightEyeProjectionNode.geometry)
        
        faceNode.setGeometryVisible(false)
        
        XCTAssertNil(faceNode.geometry)
        XCTAssertNil(faceNode.test_leftEyeNode.geometry)
        XCTAssertNil(faceNode.test_rightEyeNode.geometry)
        XCTAssertNil(faceNode.test_leftEyeProjectionNode.geometry)
        XCTAssertNil(faceNode.test_rightEyeProjectionNode.geometry)
        
        faceNode.setGeometryVisible(true)
        
        XCTAssertNotNil(faceNode.geometry)
        XCTAssertNotNil(faceNode.test_leftEyeNode.geometry)
        XCTAssertNotNil(faceNode.test_rightEyeNode.geometry)
        XCTAssertNotNil(faceNode.test_leftEyeProjectionNode.geometry)
        XCTAssertNotNil(faceNode.test_rightEyeProjectionNode.geometry)
    }
}
