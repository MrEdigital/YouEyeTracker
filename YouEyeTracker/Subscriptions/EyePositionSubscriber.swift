///
///  EyePositionSubscriber.swift
///  Created on 5/11/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import Foundation

// MARK: - Specification
///
/// Conforming to this protocol allows classes to subscribe for YouEyeTracker callbacks.
///
@objc public protocol EyePositionSubscriber: class {
    
    /// When subscribed, this is called any time YouEyeTracker updates it's current eye position
    func eyePositionMovedTo(xPosition: Float, yPosition: Float, zPosition: Float)
    
    /// When subscribed, this is called any time YouEyeTracker's Eye Tracking is interrupted
    func eyeTrackingInterrupted()
}
