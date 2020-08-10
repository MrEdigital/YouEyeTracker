///
///  Extension_Averaging_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
import simd
import SceneKit
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// Various Averaging Extension Unit Tests
///
class Extension_Averaging_Tests: XCTestCase {
    
    struct AveragingTestContainer {
        private let numA: Float
        private let numB: Float
        private let result: Float
        
        init(numA: Float, numB: Float, result: Float) {
            self.numA = numA
            self.numB = numB
            self.result = result
        }
        
        var numA_Float: Float { return numA }
        var numB_Float: Float { return numB }
        var result_Float: Float { return result }
        
        var numA_CGFloat: CGFloat { return CGFloat(numA) }
        var numB_CGFloat: CGFloat { return CGFloat(numB) }
        var result_CGFloat: CGFloat { return CGFloat(result) }
    }
    
    struct AveragingArrayTestContainer {
        private let nums: [Float]
        private let result: Float
        let clampedTo: Int?
        
        init(nums: [Float], clampedTo: Int? = nil, result: Float) {
            self.nums = nums
            self.result = result
            self.clampedTo = clampedTo
        }
        
        var nums_Float: [Float] { return nums }
        var result_Float: Float { return result }
        
        var nums_CGFloat: [CGFloat] { return nums.compactMap({ CGFloat($0) }) }
        var result_CGFloat: CGFloat { return CGFloat(result) }
    }
    
    static let averagingTests: [AveragingTestContainer] = [.init(numA: 0,   numB: 8,    result: 4),
                                                           .init(numA: 2,   numB: 8,    result: 5),
                                                           .init(numA: 0,   numB: 2048, result: 1024),
                                                           .init(numA: 512, numB: 2048, result: 1280)]
    
    static let arrayAveragingTests: [AveragingArrayTestContainer] = [.init(nums: [3,5,8,12],                                          result: 7),
                                                                     .init(nums: [3,5,8,12],                            clampedTo: 5, result: 7),
                                                                     .init(nums: [1,43,2,3,5,8,12],                     clampedTo: 4, result: 7),
                                                                     .init(nums: [4,6,6,16],                                          result: 8),
                                                                     .init(nums: [4,6,6,16],                            clampedTo: 5, result: 8),
                                                                     .init(nums: [12,2,5,4,6,6,16],                     clampedTo: 4, result: 8),
                                                                     .init(nums: [20,283,535,722,1250],                               result: 562),
                                                                     .init(nums: [20,283,535,722,1250],                 clampedTo: 6, result: 562),
                                                                     .init(nums: [1231,34,25,5665,20,283,535,722,1250], clampedTo: 5, result: 562)]
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     extension Float {
///         func averaged(by float: Float) -> Float
///     }
///
///     extension CGFloat {
///         func averaged(by float: CGFloat) -> CGFloat
///     }
///
///     extension SIMD3 where Scalar == Float {
///         func averaged(by vector: Self) -> Self
///     }
///
///     extension SIMD4 where Scalar == Float {
///         func averaged(by vector: Self) -> Self
///     }
///
///     extension SCNVector3 {
///         func averaged(by vector: SCNVector3) -> SCNVector3
///     }
///
///     extension Array where Element == CGFloat {
///         func average() -> CGFloat
///         mutating func clampThenAverage(toCount: Int) -> CGFloat
///     }
///
extension Extension_Averaging_Tests {
    
    // MARK: - T - Float Average
    ///
    /// Tests the function:
    ///
    ///     extension Float {
    ///         func averaged(by float: Float) -> Float
    ///     }
    ///
    /// The following behavior is expected:
    /// 1. The result should be half way between the two values
    ///
    func test_FloatAverage() {
        
        // Behavior #1
        
            for averagingTest in Self.averagingTests {
                XCTAssertEqual(averagingTest.numA_Float.averaged(by: averagingTest.numB_Float), averagingTest.result_Float)
                XCTAssertEqual(averagingTest.numB_Float.averaged(by: averagingTest.numA_Float), averagingTest.result_Float)
                XCTAssertEqual(averagingTest.numA_Float.averaged(by: averagingTest.numA_Float), averagingTest.numA_Float)
                XCTAssertEqual(averagingTest.numB_Float.averaged(by: averagingTest.numB_Float), averagingTest.numB_Float)
            }
    }
    
    // MARK: - T - CGFloat Average
    ///
    /// Tests the function:
    ///
    ///     extension CGFloat {
    ///         func averaged(by float: CGFloat) -> CGFloat
    ///     }
    ///
    /// The following behavior is expected:
    /// 1. The result should be half way between the two values
    ///
    func test_CGFloatAverage() {
        
        // Behavior #1
        
            for averagingTest in Self.averagingTests {
                XCTAssertEqual(averagingTest.numA_CGFloat.averaged(by: averagingTest.numB_CGFloat), averagingTest.result_CGFloat)
                XCTAssertEqual(averagingTest.numB_CGFloat.averaged(by: averagingTest.numA_CGFloat), averagingTest.result_CGFloat)
            }
    }
    
    // MARK: - T - SIMD3 Average
    ///
    /// Tests the function:
    ///
    ///     extension SIMD3 where Scalar == Float {
    ///         func averaged(by vector: Self) -> Self
    ///     }
    ///
    /// The following behavior is expected:
    /// 1. The result should be half way between the two values
    ///
    func test_SIMD3Average() {
        
        // Behavior #1
        
            for averagingTest in Self.averagingTests {
                let numA = SIMD3<Float>(averagingTest.numB_Float, averagingTest.numA_Float, averagingTest.numA_Float)
                let numB = SIMD3<Float>(averagingTest.numA_Float, averagingTest.numB_Float, averagingTest.numA_Float)
                let result = SIMD3<Float>(averagingTest.result_Float, averagingTest.result_Float, averagingTest.numA_Float)
                
                XCTAssertEqual(numA.averaged(by: numB), result)
                XCTAssertEqual(numB.averaged(by: numA), result)
            }
    }
    
    // MARK: - T - SIMD4 Average
    ///
    /// Tests the function:
    ///
    ///     extension SIMD4 where Scalar == Float {
    ///         func averaged(by vector: Self) -> Self
    ///     }
    ///
    /// The following behavior is expected:
    /// 1. The result should be half way between the two values
    ///
    func test_SIMD4Average() {
        
        // Behavior #1
        
            for averagingTest in Self.averagingTests {
                let numA = SIMD4<Float>(averagingTest.numB_Float, averagingTest.numA_Float, averagingTest.numA_Float, averagingTest.numB_Float)
                let numB = SIMD4<Float>(averagingTest.numA_Float, averagingTest.numB_Float, averagingTest.numA_Float, averagingTest.numB_Float)
                let result = SIMD4<Float>(averagingTest.result_Float, averagingTest.result_Float, averagingTest.numA_Float, averagingTest.numB_Float)
                
                XCTAssertEqual(numA.averaged(by: numB), result)
                XCTAssertEqual(numB.averaged(by: numA), result)
            }
    }
    
    // MARK: - T - SCNVector3 Average
    ///
    /// Tests the function:
    ///
    ///     extension SCNVector3 {
    ///         func averaged(by vector: SCNVector3) -> SCNVector3
    ///     }
    ///
    /// The following behavior is expected:
    /// 1. The result should be half way between the two values
    ///
    func test_SCNVector3Average() {
        
        // Behavior #1
        
            for averagingTest in Self.averagingTests {
                let numA = SCNVector3(x: averagingTest.numB_Float, y: averagingTest.numA_Float, z: averagingTest.numA_Float)
                let numB = SCNVector3(x: averagingTest.numA_Float, y: averagingTest.numB_Float, z: averagingTest.numA_Float)
                let result = SCNVector3(x: averagingTest.result_Float, y: averagingTest.result_Float, z: averagingTest.numA_Float)
                
                let averageA = numA.averaged(by: numB)
                let averageB = numB.averaged(by: numA)
                
                XCTAssertEqual(averageA.x, result.x)
                XCTAssertEqual(averageA.y, result.y)
                XCTAssertEqual(averageA.z, result.z)
                XCTAssertEqual(averageB.x, result.x)
                XCTAssertEqual(averageB.y, result.y)
                XCTAssertEqual(averageB.z, result.z)
            }
    }
    
    // MARK: - T - CGFloat Array Average
    ///
    /// Tests the functions:
    ///
    ///     extension Array where Element == CGFloat {
    ///         func average() -> CGFloat
    ///         mutating func clampThenAverage(toCount: Int) -> CGFloat
    ///     }
    ///
    /// The following behavior is expected:
    /// 1. clampThenAverage() should first remove any entries beyond the clamp count value, and then average all remaining values
    /// 2. average() should average all contained values
    /// 3. If the array is empty, the result of either should be 0
    ///
    func test_CGFloatArrayAverage() {
        
        for arrayAveragingTest in Self.arrayAveragingTests {
            if let clampCount = arrayAveragingTest.clampedTo {
                // Behavior #2
                    var mutatingArray = arrayAveragingTest.nums_CGFloat
                    XCTAssertEqual(mutatingArray.clampThenAverage(toCount: clampCount), arrayAveragingTest.result_CGFloat)
                    XCTAssertTrue(mutatingArray.count <= clampCount)
            } else {
                // Behavior #1
                    XCTAssertEqual(arrayAveragingTest.nums_CGFloat.average(), arrayAveragingTest.result_CGFloat)
            }
        }
        
        // Behavior #3
            var emptyArray: [CGFloat] = []
            XCTAssertEqual(emptyArray.average(), 0)
            XCTAssertEqual(emptyArray.clampThenAverage(toCount: 10), 0)
    }
}
