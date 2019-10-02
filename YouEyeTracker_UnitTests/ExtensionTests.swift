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
@testable import YouEyeTracker

// MARK: - Setup -
class ExtensionTests : XCTestCase {
    
    struct AveragingTest {
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
    
    struct AveragingArrayTest {
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
    
    static let matrixTests: [(matrix: matrix_float4x4, translation: SIMD3<Float>)] = [(matrix: matrix_float4x4(columns:    (.init(4.4,   8.12,  12.5,  2.4),
                                                                                                                            .init(45.2,  3.1,   6.6,   7.7),
                                                                                                                            .init(2.45,  3.45,  1.35,  7.2),
                                                                                                                            .init(1.44,  24.7,  3.466, 12.24))),
                                                                                                               translation: .init(1.44,  24.7,  3.466)),
                                                                                      (matrix: matrix_float4x4(columns:    (.init(7.2,   43.4,  21.87, 34.18),
                                                                                                                            .init(4.35,  15.2,  14.3,  24.75),
                                                                                                                            .init(6.35,  7.25,  7515,  2.456),
                                                                                                                            .init(28.52, 2.48,  842.1, 24.2))),
                                                                                                               translation: .init(28.52, 2.48,  842.1)),
                                                                                      (matrix: matrix_float4x4(columns:    (.init(6.35,  7.25,  7515,  2.456),
                                                                                                                            .init(1.44,  24.7,  3.466, 12.24),
                                                                                                                            .init(45.2,  3.1,   6.6,   7.7),
                                                                                                                            .init(22.7,  27.5,  752.1, 1.1))),
                                                                                                               translation: .init(22.7,  27.5,  752.1))]
    
    static let averagingTests: [AveragingTest] = [.init(numA: 0,   numB: 8,    result: 4),
                                                  .init(numA: 2,   numB: 8,    result: 5),
                                                  .init(numA: 0,   numB: 2048, result: 1024),
                                                  .init(numA: 512, numB: 2048, result: 1280)]
    
    static let arrayAveragingTests: [AveragingArrayTest] = [.init(nums: [3,5,8,12],                                          result: 7),
                                                            .init(nums: [3,5,8,12],                            clampedTo: 5, result: 7),
                                                            .init(nums: [1,43,2,3,5,8,12],                     clampedTo: 4, result: 7),
                                                            .init(nums: [4,6,6,16],                                          result: 8),
                                                            .init(nums: [4,6,6,16],                            clampedTo: 5, result: 8),
                                                            .init(nums: [12,2,5,4,6,6,16],                     clampedTo: 4, result: 8),
                                                            .init(nums: [20,283,535,722,1250],                               result: 562),
                                                            .init(nums: [20,283,535,722,1250],                 clampedTo: 6, result: 562),
                                                            .init(nums: [1231,34,25,5665,20,283,535,722,1250], clampedTo: 5, result: 562)]
}

// MARK: - Averaging Tests -
extension ExtensionTests {
    
    func test_FloatAverage() {
        
        for averagingTest in ExtensionTests.averagingTests {
            XCTAssertEqual(averagingTest.numA_Float.averaged(by: averagingTest.numB_Float), averagingTest.result_Float)
            XCTAssertEqual(averagingTest.numB_Float.averaged(by: averagingTest.numA_Float), averagingTest.result_Float)
            XCTAssertEqual(averagingTest.numA_Float.averaged(by: averagingTest.numA_Float), averagingTest.numA_Float)
            XCTAssertEqual(averagingTest.numB_Float.averaged(by: averagingTest.numB_Float), averagingTest.numB_Float)
        }
    }
    
    func test_CGFloatAverage() {
        
        for averagingTest in ExtensionTests.averagingTests {
            XCTAssertEqual(averagingTest.numA_CGFloat.averaged(by: averagingTest.numB_CGFloat), averagingTest.result_CGFloat)
            XCTAssertEqual(averagingTest.numB_CGFloat.averaged(by: averagingTest.numA_CGFloat), averagingTest.result_CGFloat)
        }
    }
    
    func test_SIMD3Average() {
        
        for averagingTest in ExtensionTests.averagingTests {
            let numA = SIMD3<Float>(averagingTest.numB_Float, averagingTest.numA_Float, averagingTest.numA_Float)
            let numB = SIMD3<Float>(averagingTest.numA_Float, averagingTest.numB_Float, averagingTest.numA_Float)
            let result = SIMD3<Float>(averagingTest.result_Float, averagingTest.result_Float, averagingTest.numA_Float)
            
            XCTAssertEqual(numA.averaged(by: numB), result)
            XCTAssertEqual(numB.averaged(by: numA), result)
        }
    }
    
    func test_SIMD4Average() {
        
        for averagingTest in ExtensionTests.averagingTests {
            let numA = SIMD4<Float>(averagingTest.numB_Float, averagingTest.numA_Float, averagingTest.numA_Float, averagingTest.numB_Float)
            let numB = SIMD4<Float>(averagingTest.numA_Float, averagingTest.numB_Float, averagingTest.numA_Float, averagingTest.numB_Float)
            let result = SIMD4<Float>(averagingTest.result_Float, averagingTest.result_Float, averagingTest.numA_Float, averagingTest.numB_Float)
            
            XCTAssertEqual(numA.averaged(by: numB), result)
            XCTAssertEqual(numB.averaged(by: numA), result)
        }
    }
    
    func test_SCNVector3Average() {
        
        for averagingTest in ExtensionTests.averagingTests {
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
    
    func test_CGFloatArrayAverage() {
        
        for arrayAveragingTest in ExtensionTests.arrayAveragingTests {
            if let clampCount = arrayAveragingTest.clampedTo {
                var mutatingArray = arrayAveragingTest.nums_CGFloat
                XCTAssertEqual(mutatingArray.clampThenAverage(toCount: clampCount), arrayAveragingTest.result_CGFloat)
                XCTAssertTrue(mutatingArray.count <= clampCount)
            } else {
                XCTAssertEqual(arrayAveragingTest.nums_CGFloat.average(), arrayAveragingTest.result_CGFloat)
            }
        }
        
        let emptyArray: [CGFloat] = []
        XCTAssertEqual(emptyArray.average(), 0)
    }
}

// MARK: - Matrix Tests -
extension ExtensionTests {
    
    func test_matrixTranslation() {
        
        for matrixTest in ExtensionTests.matrixTests {
            XCTAssertEqual(matrixTest.matrix.translation, matrixTest.translation)
        }
    }
}
