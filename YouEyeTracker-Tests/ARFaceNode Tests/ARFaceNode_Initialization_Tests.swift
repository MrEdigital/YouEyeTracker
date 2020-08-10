///
///  ARFaceNode_Initialization_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// ARFaceNode Unit Tests - Initialization
///
class ARFaceNode_Initialization_Tests: XCTestCase {
    typealias ARFaceNode = YouEyeTracker.ARFaceNode
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     public init()
///     required init?(coder aDecoder: NSCoder)
///
extension ARFaceNode_Initialization_Tests {
    
    // MARK: - T - Init
    ///
    /// Tests the function:
    ///
    ///     public init()
    ///
    /// The following behavior is expected:
    /// 1. The left and right eye nodes should each be added as children to the faceNode
    /// 2. The left and right projection nodes should be added to their respective eye nodes
    ///
    func test_init() {
        
        let faceNode = ARFaceNode()
        
        // Behavior #1
            XCTAssertEqual(faceNode.test_leftEyeNode.parent, faceNode)
            XCTAssertEqual(faceNode.test_rightEyeNode.parent, faceNode)
        
        // Behavior #2
            XCTAssertEqual(faceNode.test_leftEyeProjectionNode.parent, faceNode.test_leftEyeNode)
            XCTAssertEqual(faceNode.test_rightEyeProjectionNode.parent, faceNode.test_rightEyeNode)
    }
    
    // MARK: - T - Init With Coder
    ///
    /// Tests the function:
    ///
    ///     required init?(coder aDecoder: NSCoder)
    ///
    /// The following behavior is expected:
    /// 1. The left and right eye nodes should each be added as children to the faceNode
    /// 2. The left and right projection nodes should be added to their respective eye nodes
    ///
    func test_initWithCoder() {
        
        let faceNode = ARFaceNode.init(coder: Coder())
        
        // I don't care for restorability in this case, so this is simply a test to ensure it hits setup() via init?(coder aDecoder:)
        XCTAssertEqual(faceNode?.test_leftEyeNode.parent, faceNode)
        XCTAssertEqual(faceNode?.test_rightEyeNode.parent, faceNode)
        XCTAssertEqual(faceNode?.test_leftEyeProjectionNode.parent, faceNode?.test_leftEyeNode)
        XCTAssertEqual(faceNode?.test_rightEyeProjectionNode.parent, faceNode?.test_rightEyeNode)
    }
}

// MARK: - Helper Classes

extension ARFaceNode_Initialization_Tests {
    
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
}
