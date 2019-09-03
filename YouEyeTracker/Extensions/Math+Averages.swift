//
//  Math+Averages.swift
//  YouEyeTracker
//
//  Created on 5/11/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

import simd
import SceneKit

extension Array where Element == CGFloat {
    func average() -> CGFloat {
        guard !isEmpty else { return 0 }
        let total = reduce(CGFloat(0)) { $0 + $1 }
        return total / CGFloat(count)
    }
    
    mutating func clampThenAverage(toCount: Int) -> CGFloat {
        if count > toCount { removeFirst(count - toCount) }
        return average()
    }
}

extension SCNVector3 {
    func averaged(by vector: SCNVector3) -> SCNVector3 {
        return SCNVector3(x.averaged(by: vector.x),
                          y.averaged(by: vector.y),
                          z.averaged(by: vector.z))
    }
}

extension float4 {
    func averaged(by vector: float4) -> float4 {
        return float4(x.averaged(by: vector.x),
                      y.averaged(by: vector.y),
                      z.averaged(by: vector.z),
                      w.averaged(by: vector.w))
    }
}

extension float3 {
    func averaged(by vector: float3) -> float3 {
        return float3(x.averaged(by: vector.x),
                      y.averaged(by: vector.y),
                      z.averaged(by: vector.z))
    }
}

extension Float {
    func averaged(by float: Float) -> Float {
        return self + (float - self)/2
    }
}

extension CGFloat {
    func averaged(by float: CGFloat) -> CGFloat {
        return self + (float - self)/2
    }
}
