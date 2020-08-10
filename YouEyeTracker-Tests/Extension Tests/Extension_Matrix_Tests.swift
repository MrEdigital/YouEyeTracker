///
///  Extension_Matrix_Tests.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import XCTest
import simd
@testable import YouEyeTracker

// MARK: - Setup / Cleanup...
///
/// Matrix Extension Unit Tests
///
class Extension_Matrix_Tests: XCTestCase {
    
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
}

// MARK: - Tests...
///
/// Covering the following accessors:
///
///     var translation: SIMD3<Float>
///
extension Extension_Matrix_Tests {
    
    // MARK: - T - Translation
    ///
    /// Tests the function:
    ///
    ///     var translation: SIMD3<Float>
    ///
    /// The following behavior is expected:
    /// 1. The resulting value should match SIMD3<Float>(columns.3.x, columns.3.y, columns.3.z)
    ///
    func test_translation() {
        
        // Behavior #1
            for matrixTest in Self.matrixTests {
                XCTAssertEqual(matrixTest.matrix.translation, matrixTest.translation)
            }
    }
}
