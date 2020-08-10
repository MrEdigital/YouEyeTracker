///
///  FaceAnchor.swift
///  Created on 9/28/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import ARKit

// MARK: - Specification
///
/// I've only created this protocol because ARFaceAnchor's initializer is, at this time, unreliable.
/// When I try creating an ARFaceAnchor in my unit tests by initializing it with an ARAnchor, which initializes with an
/// empty matrix, there is a good ( > 20%) chance that it will subsequently crash when running that line.  This allows
/// me to still test relevant behavior despite that.
///
protocol FaceAnchor: class {
    var transform: matrix_float4x4 { get }
    var leftEyeTransform: matrix_float4x4 { get }
    var rightEyeTransform: matrix_float4x4 { get }
}
extension ARFaceAnchor: FaceAnchor {}
