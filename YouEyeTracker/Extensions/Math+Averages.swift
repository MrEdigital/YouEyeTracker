//
//  Math+Averages.swift
//  YouEyeTracker
//
//  Created on 5/11/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

import simd
import SceneKit

extension Float {
    
    ///
    /// - Parameter float: The other Float with which to average a result
    /// - Returns: The average result of this and some other supplied Float.
    ///
    func averaged(by float: Float) -> Float {
        return self + (float - self)/2
    }
}

extension CGFloat {
    
    ///
    /// - Parameter float: The other CGFloat with which to average a result
    /// - Returns: The average result of this and some other supplied CGFloat.
    ///
    func averaged(by float: CGFloat) -> CGFloat {
        return self + (float - self)/2
    }
}

extension SIMD3 where Scalar == Float {
    
    ///
    /// - Parameter vector: The other SIMD3 with which to average a result
    /// - Returns: The average result of this and some other supplied SIMD3.
    ///
    func averaged(by vector: Self) -> Self {
        return .init(x.averaged(by: vector.x),
                     y.averaged(by: vector.y),
                     z.averaged(by: vector.z))
    }
}

extension SIMD4 where Scalar == Float {
    
    ///
    /// - Parameter vector: The other SIMD4 with which to average a result
    /// - Returns: The average result of this and some other supplied SIMD4.
    ///
    func averaged(by vector: Self) -> Self {
        return .init(x.averaged(by: vector.x),
                     y.averaged(by: vector.y),
                     z.averaged(by: vector.z),
                     w.averaged(by: vector.w))
    }
}

extension SCNVector3 {
    
    ///
    /// - Parameter vector: The other SCNVector3 with which to average a result
    /// - Returns: The average result of this and some other supplied SCNVector3.
    ///
    func averaged(by vector: SCNVector3) -> SCNVector3 {
        return SCNVector3(x.averaged(by: vector.x),
                          y.averaged(by: vector.y),
                          z.averaged(by: vector.z))
    }
}

extension Array where Element == CGFloat {
    
    ///
    /// - Returns: The average result of all CGFloats held within.
    ///
    func average() -> CGFloat {
        guard !isEmpty, let smallest = self.min() else { return 0 }
        let total = reduce(CGFloat(0)) { $0 + ($1 - smallest) }
        return total / CGFloat(count) + smallest
    }
    
    ///
    /// Reduces the Array down to the specified number of elements last appended, and returns the average of the remainder.
    ///
    /// - Parameter toCount: The maximum number of last objects added to the array you would like to have averaged.
    ///
    mutating func clampThenAverage(toCount: Int) -> CGFloat {
        if count > toCount { removeFirst(count - toCount) }
        return average()
    }
}
