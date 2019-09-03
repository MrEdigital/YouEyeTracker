//
//  YouEyeTracker.swift
//  YouEyeTracker
//
//  Created on 5/11/19.
//  Copyright © 2019 Eric Reedy. All rights reserved.
//

import ARKit

///
/// This class whose name, most importantly, contains a pun, utilizes ARKit to track a user's
/// eye position (left, right, or middle) in real-world space, relative to the position of the front-facing
/// camera.  It then broadcasts those changes in posititon to all registered subscribers.
///
/// Singleton Accessor:
///
///     public let shared : Self
///
/// Primary Usage:
///
///     func configure(with configuration: YouEyeTracker.Config)
///     func start()
///     func stop()
///     func subscribe(_ subscriber: EyePositionSubscriber)
///
/// - Note:
/// This class originally provided Gaze tracking calculations and callbacks in addition to eye
/// position, but after much experimentation, I just don't think it's accurate enough for anyone to
/// find particularly useful at this time.  So with the intent of lightening the load of this class
/// I have left it out entirely.
///
public // MARK: - Class Definition -
class YouEyeTracker : NSObject {
    
    /// The primary class singleton
    public static let shared             : YouEyeTracker = .init()
    
    /// Making the internal sceneView public for those who would like to visualize their values
    public  let sceneView                : ARSCNView    = .init()
    
    private let faceNode                 : ARFaceNode   = .init()
    private var trackedEyePosition       : float3?      { didSet { broadcastEyePositionMoved(to: trackedEyePosition) }}
    private var eyePositionSubscribers   : [ARPositionSubscriberWrapper] = []
    private var subscriptionCleanupTimer : Timer?
    
    private override init() {
        super.init()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.scene.rootNode.addChildNode(faceNode)
        subscriptionCleanupTimer = .scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] _ in
            self?.purgeSubscribersIfNeeded()
        })
    }
    
    deinit {
        if let subscriptionCleanupTimer = subscriptionCleanupTimer {
            subscriptionCleanupTimer.invalidate()
            self.subscriptionCleanupTimer = nil
        }
        eyePositionSubscribers.removeAll()
    }
}

public // MARK: - Starting / Stopping -
extension YouEyeTracker {
    
    /// This starts the eye tracking processes of YouEyeTracker
    func start() {
        resetTracking()
    }
    
    // This stops the eye tracking processes of YouEyeTracker
    func stop()  {
        stopTracking()
        broadcastEyeTrackingInerruption()
    }
}

public // MARK: - Subscribing -
extension YouEyeTracker {
    
    private
    class ARPositionSubscriberWrapper {
        weak var subscriber: EyePositionSubscriber?
        init(subscriber: EyePositionSubscriber) { self.subscriber = subscriber }
    }
    
    // This allows conforming classes to subscribe to YouEyeTracker for protocol-defined callbacks
    func subscribe(_ subscriber: EyePositionSubscriber) {
        eyePositionSubscribers.append(.init(subscriber: subscriber))
    }
}

private // MARK: - Subscriber Broadcasting -
extension YouEyeTracker {
    
    // Broadcasting
    func broadcastEyePositionMoved(to position: float3?) {
        eyePositionSubscribers.forEach { $0.subscriber?.eyePositionMovedTo(position: position) }
    }
    
    func broadcastEyeTrackingInerruption() {
        eyePositionSubscribers.forEach { $0.subscriber?.eyeTrackingInterrupted() }
    }
    
    // Cleanup
    func purgeSubscribersIfNeeded() {
        eyePositionSubscribers = eyePositionSubscribers.filter { $0.subscriber != nil }
    }
}

private // MARK: - Internal Behavior -
extension YouEyeTracker {
    
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.worldAlignment = .camera
        configuration.isLightEstimationEnabled = false
        
        stopTracking()
        sceneView.session = .init()
        sceneView.session.delegate = self
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func stopTracking() {
        sceneView.session.delegate = nil
        sceneView.session.pause()
    }
}

// MARK: - ARSession Delegate Conformance -
extension YouEyeTracker : ARSessionDelegate {
    
    public func session(_ session: ARSession, didFailWithError error: Error) {
        broadcastEyeTrackingInerruption()
        resetTracking()
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard #available(iOS 12.0, *) else { return }
        
        if let faceAnchor = anchors.first(where: { $0 is ARFaceAnchor }) as? ARFaceAnchor {
            faceNode.update(from: faceAnchor)
            trackedEyePosition = float3(faceNode.eyePosition(for: YouEyeTracker.pointOfView))
        }
    }
    
    public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
            case .notAvailable: broadcastEyeTrackingInerruption()
            default: return
        }
    }
}

internal // MARK: - Debugging / Deomonstration -
extension YouEyeTracker {
    
    func setGeometryVisible(_ geometryVisible: Bool) {
        faceNode.setGeometryVisible(geometryVisible)
    }
}
