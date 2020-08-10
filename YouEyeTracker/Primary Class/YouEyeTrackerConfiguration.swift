///
///  YouEyeTrackerConfiguration.swift
///  Created on 5/11/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import ARKit

extension YouEyeTracker {
    
    public struct Config {
        
        public enum PointOfView {
            case leftEye, rightEye, eyeAverage
        }
        
        var pointOfView: PointOfView?
        var showTrackingInSceneView: Bool
        
        ///
        /// - parameter pointOfView:             The point in which the user's perspective calculations should be
        ///                                      relative to.
        /// - parameter showTrackingInSceneView: Populates the underlying SceneKit view with Geometry, so that tracking
        ///                                      can be visualized should the view be presented.
        ///
        public init(pointOfView: Config.PointOfView? = nil, showTrackingInSceneView: Bool = false) {
            self.pointOfView = pointOfView
            self.showTrackingInSceneView = showTrackingInSceneView
        }
    }
}
