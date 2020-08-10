///
///  float4x4+Translation.swift
///  Created on 5/11/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import simd

extension matrix_float4x4 {
    
    ///
    /// - Returns: the translation portion of the 4x4 matrix.
    ///
    var translation: SIMD3<Float> {
        return .init(columns.3.x, columns.3.y, columns.3.z)
    }
}
