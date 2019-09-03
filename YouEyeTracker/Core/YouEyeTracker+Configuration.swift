//
//  YouEyeTracker+Configuration.swift
//  YouEyeTracker
//
//  Created on 5/11/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

import ARKit

public
extension YouEyeTracker {
    
    static var pointOfView             : Config.PointOfView? = nil
    static var showTrackingInSceneView : Bool      = false { didSet { shared.setGeometryVisible(showTrackingInSceneView) }}
    
    /// This configures YouEyeTracker using the supplied configuration.
    ///
    static func configure(with configuration: Config) {
        pointOfView = configuration.pointOfView
        showTrackingInSceneView = configuration.showTrackingInSceneView
    }
    
    struct Config {
        
        public
        enum PointOfView {
            case leftEye, rightEye, eyeAverage
        }
        
        var pointOfView: PointOfView?
        var showTrackingInSceneView: Bool
        
        /// - Parameters:
        ///     - pointOfView: The point in which the user's perspective calculations should be relative to.
        ///     - showTrackingInSceneView: Populates the underlying SceneKit view with Geometry, so that tracking
        ///       can be visualized should the view be presented.
        ///
        public init(pointOfView: Config.PointOfView? = nil, showTrackingInSceneView: Bool = false) {
            self.pointOfView = pointOfView
            self.showTrackingInSceneView = showTrackingInSceneView
        }
    }
}
