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
public // MARK: - Setup -
class YouEyeTracker : NSObject {
    
    /// The primary class singleton.  A pattern ~everybody~ loves.
    public static let shared             : YouEyeTracker = .init()
    
    /// Making the internal sceneView public for those who would like to visualize their values
    public  let sceneView                : ARSCNView     = .init()
    
    private var faceNode                 : ARFaceNode    = .init()
    private var trackedEyePosition       : SIMD3<Float>? { didSet { broadcastEyePositionMoved(to: trackedEyePosition) }}
    private let subscriptionManager      : SubscriptionManager<EyePositionSubscriber> = .init()
    
    private override init() {
        super.init()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.scene.rootNode.addChildNode(faceNode)
    }
}

public // MARK: - Starting / Stopping -
extension YouEyeTracker {
    
    /// This starts the eye tracking processes of YouEyeTracker
    func start() {
        resetTracking()
    }
    
    /// This stops the eye tracking processes of YouEyeTracker
    func stop()  {
        stopTracking()
        broadcastEyeTrackingInerruption()
    }
}

public // MARK: - Subscribing -
extension YouEyeTracker {
    
    /// This allows conforming classes to subscribe to YouEyeTracker for protocol-defined callbacks
    func subscribe(_ subscriber: EyePositionSubscriber) {
        subscriptionManager.subscribe(subscriber)
    }
}

private // MARK: - Subscriber Broadcasting -
extension YouEyeTracker {
    
    // Broadcasting
    func broadcastEyePositionMoved(to position: SIMD3<Float>?) {
        guard let position = position else {
            subscriptionManager.subscribers.forEach { $0.subscriber?.eyeTrackingInterrupted() }
            return
        }
        subscriptionManager.subscribers.forEach { $0.subscriber?.eyePositionMovedTo(xPosition: position.x, yPosition: position.y, zPosition: position.z) }
    }
    
    func broadcastEyeTrackingInerruption() {
        subscriptionManager.subscribers.forEach { $0.subscriber?.eyeTrackingInterrupted() }
    }
}

private // MARK: - Internal Behavior -
extension YouEyeTracker {
    
    func resetTracking() {
        
        #if !DEBUG
        guard ARFaceTrackingConfiguration.isSupported else { return }
        #endif
        
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
    
    public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) { cameraTrackingStateDidChange(to: camera.trackingState) }
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor])                 { updateFromAnchor(anchors.first(where: { $0 is FaceAnchor }) as? FaceAnchor) }
    public func session(_ session: ARSession, didFailWithError error: Error) {
        broadcastEyeTrackingInerruption()
        resetTracking()
    }
    
    func cameraTrackingStateDidChange(to trackingState: ARCamera.TrackingState) {
        switch trackingState {
            case .notAvailable: broadcastEyeTrackingInerruption()
            default: return
        }
    }
    
    func updateFromAnchor(_ faceAnchor: FaceAnchor?) {
        guard let faceAnchor = faceAnchor else { return }
        faceNode.update(fromFaceTransform: faceAnchor.transform, leftEyeTransform: faceAnchor.leftEyeTransform, rightEyeTransform: faceAnchor.rightEyeTransform)
        trackedEyePosition = .init(faceNode.eyePosition(for: YouEyeTracker.pointOfView))
    }
}

internal // MARK: - Debugging / Deomonstration -
extension YouEyeTracker {
    
    func setGeometryVisible(_ geometryVisible: Bool) {
        faceNode.setGeometryVisible(geometryVisible)
    }
}

// MARK: - Private access for Unit Testing -
#if DEBUG

extension YouEyeTracker {
    
    static func testInit() -> YouEyeTracker {
        return .init()
    }
    
    func test_overrideFaceNode(with faceNode: ARFaceNode) {
        self.faceNode = faceNode
    }
    
    func test_broadcastEyePositionMoved(to position: SIMD3<Float>?) {
        broadcastEyePositionMoved(to: position)
    }
    
    func test_broadcastEyeTrackingInerruption() {
        broadcastEyeTrackingInerruption()
    }
}

#endif
