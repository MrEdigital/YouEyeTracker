//
//  ARFaceNode.swift
//  YouEyeTracker
//
//  Created on 5/11/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

import ARKit

extension YouEyeTracker {
    
    class ARFaceNode : SCNNode {
    
        private let leftEyeNode             : SCNNode   = .init()
        private let leftEyeProjectionNode   : SCNNode   = .init()
        private let rightEyeNode            : SCNNode   = .init()
        private let rightEyeProjectionNode  : SCNNode   = .init()
        
        override public init() {
            super.init()
            
            // Setup the Face Node Hierarchy
            addChildNode(leftEyeNode)
            addChildNode(rightEyeNode)
            leftEyeNode.addChildNode(leftEyeProjectionNode)
            rightEyeNode.addChildNode(rightEyeProjectionNode)
            
            // Extend the Projection Nodes well into the distance
            leftEyeProjectionNode.position.z  = 1
            rightEyeProjectionNode.position.z = 1
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func update(from faceAnchor: ARFaceAnchor) {
            simdTransform = faceAnchor.transform
            leftEyeNode.simdTransform = faceAnchor.leftEyeTransform
            rightEyeNode.simdTransform = faceAnchor.rightEyeTransform
        }
        
        func eyePosition(for trackedEye: Config.PointOfView?) -> SCNVector3 {
            guard let trackedEye = trackedEye else { return SCNVector3Zero }
            
            switch trackedEye {
                case .leftEye:    return leftEyeNode.worldPosition
                case .rightEye:   return rightEyeNode.worldPosition
                case .eyeAverage: return eyePosition(for: .leftEye).averaged(by: eyePosition(for: .rightEye))
            }
        }
        
        func eyeProjectionPosition(for trackedEye: Config.PointOfView) -> SCNVector3 {
            
            switch trackedEye {
                case .leftEye:    return leftEyeProjectionNode.worldPosition
                case .rightEye:   return rightEyeProjectionNode.worldPosition
                case .eyeAverage: return eyeProjectionPosition(for: .leftEye).averaged(by: eyeProjectionPosition(for: .rightEye))
            }
        }
        
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
}
