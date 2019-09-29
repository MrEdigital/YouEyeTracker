//
//  ARFaceNode.swift
//  YouEyeTracker
//
//  Created on 5/11/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

import ARKit

extension YouEyeTracker {
    
    ///
    /// A SceneKit node node created to accept ARFaceAnchor transforms, and return back face-based positions in world space.
    /// It can, additionally, be made visible for inclusion within a scene.
    ///
    class ARFaceNode : SCNNode {
        
        private static let eyeProjectionDistance : Float = 1
    
        private let leftEyeNode             : SCNNode   = .init()
        private let leftEyeProjectionNode   : SCNNode   = .init()
        private let rightEyeNode            : SCNNode   = .init()
        private let rightEyeProjectionNode  : SCNNode   = .init()
        
        override public init() {
            super.init()
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private
        func setup() {
            // Setup the Face Node Hierarchy
            addChildNode(leftEyeNode)
            addChildNode(rightEyeNode)
            leftEyeNode.addChildNode(leftEyeProjectionNode)
            rightEyeNode.addChildNode(rightEyeProjectionNode)
            
            // Extend the Projection Nodes well into the distance
            leftEyeProjectionNode.position.z  = ARFaceNode.eyeProjectionDistance
            rightEyeProjectionNode.position.z = ARFaceNode.eyeProjectionDistance
        }
    }
}

extension YouEyeTracker.ARFaceNode {
        
    ///
    /// Applies the transform, leftEyeTransform, and rightEyeTransform to relevant nodes, such that their world positions, orientations, etc, can easily be determined.
    ///
    @objc dynamic
    func update(fromFaceTransform faceTransform: matrix_float4x4, leftEyeTransform: matrix_float4x4, rightEyeTransform: matrix_float4x4) {
        simdTransform = faceTransform
        leftEyeNode.simdTransform = leftEyeTransform
        rightEyeNode.simdTransform = rightEyeTransform
    }
    
    ///
    /// - Parameter pointOfView: Specifies a point of view which determines the eyePosition to be returned.
    ///
    /// - Returns: The world position of a user's eye.
    ///
    func eyePosition(for pointOfView: YouEyeTracker.Config.PointOfView?) -> SCNVector3 {
        guard let pointOfView = pointOfView else { return SCNVector3Zero }
        
        switch pointOfView {
            case .leftEye:    return leftEyeNode.worldPosition
            case .rightEye:   return rightEyeNode.worldPosition
            case .eyeAverage: return eyePosition(for: .leftEye).averaged(by: eyePosition(for: .rightEye))
        }
    }
    
    ///
    /// - Parameter pointOfView: Specifies a point of view which determines the eyeProjectionPosition to be returned.
    ///
    /// - Returns: The world position projected outward some distance from the pupil of a user's eye.
    ///
    func eyeProjectionPosition(for pointOfView: YouEyeTracker.Config.PointOfView) -> SCNVector3 {
        switch pointOfView {
            case .leftEye:    return leftEyeProjectionNode.worldPosition
            case .rightEye:   return rightEyeProjectionNode.worldPosition
            case .eyeAverage: return eyeProjectionPosition(for: .leftEye).averaged(by: eyeProjectionPosition(for: .rightEye))
        }
    }
    
    ///
    /// Provides a simple means of toggling geometry visibility within the Scenekit Scene.
    ///
    /// - Parameter geometryVisible: Determines whether or not the geometry should be visible.
    ///
    @objc dynamic
    func setGeometryVisible(_ geometryVisible: Bool) {
        
        if geometryVisible {
            if geometry == nil {
                geometry = SCNBox(width: 0.02, height: 0.02, length: 0.02, chamferRadius: 0)
                leftEyeNode.geometry = SCNSphere(radius: 0.01)
                rightEyeNode.geometry = SCNSphere(radius: 0.01)
                leftEyeProjectionNode.geometry = SCNBox(width: 0.001, height: 0.001, length: 2, chamferRadius: 0)
                rightEyeProjectionNode.geometry = SCNBox(width: 0.001, height: 0.001, length: 2, chamferRadius: 0)
                
                geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                leftEyeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
                rightEyeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
                leftEyeProjectionNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                rightEyeProjectionNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
        } else {
            geometry = nil
            leftEyeNode.geometry = nil
            rightEyeNode.geometry = nil
            leftEyeProjectionNode.geometry = nil
            rightEyeProjectionNode.geometry = nil
        }
    }
}

// MARK: - Private access for Unit Testing -
#if DEBUG

extension YouEyeTracker.ARFaceNode {
    
    var test_leftEyeNode             : SCNNode { return self.leftEyeNode }
    var test_leftEyeProjectionNode   : SCNNode { return self.leftEyeProjectionNode }
    var test_rightEyeNode            : SCNNode { return self.rightEyeNode }
    var test_rightEyeProjectionNode  : SCNNode { return self.rightEyeProjectionNode }
}

#endif
