//
//  EyePositionSubscriber.swift
//  YouEyeTracker
//
//  Created on 5/11/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

import simd

///
/// Conforming to this protocol allows classes to subscribe for YouEyeTracker callbacks
///
/// - note:
///   In order to use the float3 that's returned, you're going to want to:
///
///       import simd
///
public // MARK: - Eye Position Protocol Definition -
protocol EyePositionSubscriber : class {
    
    /// When subscribed, this is called any time YouEyeTracker updates it's current eye position
    func eyePositionMovedTo(position: float3?)
    
    /// When subscribed, this is called any time YouEyeTracker's Eye Tracking is interrupted
    func eyeTrackingInterrupted()
}
