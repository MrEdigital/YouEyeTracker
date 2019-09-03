//
//  float4x4+Translation.swift
//  YouEyeTracker
//
//  Created on 5/11/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

import simd

extension matrix_float4x4 {
    var translation: float3 {
        return float3(columns.3.x, columns.3.y, columns.3.z)
    }
}
