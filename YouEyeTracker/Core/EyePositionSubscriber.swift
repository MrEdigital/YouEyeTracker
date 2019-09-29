//
//  EyePositionSubscriber.swift
//  YouEyeTracker
//
//  Created on 5/11/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

///
/// Conforming to this protocol allows classes to subscribe for YouEyeTracker callbacks.
///
@objc public // MARK: - Eye Position Protocol Definition -
protocol EyePositionSubscriber : class {
    
    /// When subscribed, this is called any time YouEyeTracker updates it's current eye position
    func eyePositionMovedTo(xPosition: Float, yPosition: Float, zPosition: Float)
    
    /// When subscribed, this is called any time YouEyeTracker's Eye Tracking is interrupted
    func eyeTrackingInterrupted()
}
