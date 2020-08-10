///
///  YouEyeTracker.swift
///  Created on 5/11/19
///  Copyright © 2019 Eric Reedy. All rights reserved.
///

import ARKit

// MARK: - Specificiation
///
/// This class whose name, most importantly, is based on a pun, utilizes ARKit to track a user's eye position (left,
/// right, or middle) in real-world space, relative to the position of the front-facing camera.  It then broadcasts
/// those changes in posititon to all registered subscribers.
///
/// Singleton Accessor:
///
///     public let shared : Self
///
/// Primary Usage:
///
///     func configure(with configuration: YouEyeTracker.Config)
///     func subscribe(_ subscriber: EyePositionSubscriber)
///     func start()
///     func stop()
///
/// - Note: This class originally provided Gaze tracking calculations and callbacks in addition to eye position, but
///         after much experimentation, I just don't think it's accurate enough for anyone to find particularly useful
///         at this time.  So with the intent of lightening the load of this class I have left it out entirely.
///
public class YouEyeTracker : NSObject {
    
    /// The primary class singleton.  A pattern ~everybody~ loves.
    public static let shared             : YouEyeTracker       = .init()
    
    /// Making the internal sceneView public for those who would like to visualize this class's values
    public  let sceneView                : ARSCNView           = .init()
    
    // Private Variables
    private var faceNode                 : ARFaceNode          = .init()
    private var trackedEyePosition       : SIMD3<Float>?       = nil { didSet { broadcastEyePositionMoved(to: trackedEyePosition) }}
    private var showTrackingInSceneView  : Bool                = false { didSet { setGeometryVisible(showTrackingInSceneView) }}
    private var pointOfView              : Config.PointOfView? = nil
    private let subscriptionManager      : SubscriptionManager<EyePositionSubscriber> = .init()
    
    private override init() {
        super.init()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.scene.rootNode.addChildNode(faceNode)
    }
}

// MARK: - Configuration

extension YouEyeTracker {
    
    ///
    /// This configures YouEyeTracker using the supplied configuration.
    ///
    public func configure(with configuration: Config) {
        pointOfView = configuration.pointOfView
        showTrackingInSceneView = configuration.showTrackingInSceneView
    }
}

// MARK: - Starting / Stopping

extension YouEyeTracker {
    
    /// This starts the eye tracking processes of YouEyeTracker
    public func start() {
        resetTracking()
    }
    
    /// This stops the eye tracking processes of YouEyeTracker
    public func stop()  {
        stopTracking()
        broadcastEyeTrackingInerruption()
    }
}

// MARK: - Subscribing

extension YouEyeTracker {
    
    /// This allows conforming classes to subscribe to YouEyeTracker for protocol-defined callbacks
    public func subscribe(_ subscriber: EyePositionSubscriber) {
        subscriptionManager.subscribe(subscriber)
    }
}

// MARK: - Subscriber Broadcasting

extension YouEyeTracker {
    
    private func broadcastEyePositionMoved(to position: SIMD3<Float>?) {
        guard let position = position else {
            subscriptionManager.subscribers.forEach { $0.subscriber?.eyeTrackingInterrupted() }
            return
        }
        subscriptionManager.subscribers.forEach { $0.subscriber?.eyePositionMovedTo(xPosition: position.x, yPosition: position.y, zPosition: position.z) }
    }
    
    private func broadcastEyeTrackingInerruption() {
        subscriptionManager.subscribers.forEach { $0.subscriber?.eyeTrackingInterrupted() }
    }
}

// MARK: - Internal Behavior

extension YouEyeTracker {
    
    private func resetTracking() {
        
        #if !TESTING
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
    
    private func stopTracking() {
        sceneView.session.delegate = nil
        sceneView.session.pause()
    }
}

// MARK: - ARSession Delegate Conformance

extension YouEyeTracker : ARSessionDelegate {
    
    public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) { cameraTrackingStateDidChange(to: camera.trackingState) }
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) { updateFromAnchor(anchors.first(where: { $0 is FaceAnchor }) as? FaceAnchor) }
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
        trackedEyePosition = .init(faceNode.eyePosition(for: pointOfView))
    }
}

// MARK: - Debugging / Deomonstration

extension YouEyeTracker {
    
    func setGeometryVisible(_ geometryVisible: Bool) {
        faceNode.setGeometryVisible(geometryVisible)
    }
}

// MARK: - Testing Accessors

#if TESTING
    extension YouEyeTracker {
        static func testInit<T>() -> T where T: NSObject { return .init() }
        var test_pointOfView: Config.PointOfView? { pointOfView }
        var test_showTrackingInSceneView: Bool { showTrackingInSceneView }
        func test_overrideFaceNode(with faceNode: ARFaceNode) { self.faceNode = faceNode }
        func test_broadcastEyePositionMoved(to position: SIMD3<Float>?) { broadcastEyePositionMoved(to: position) }
        func test_broadcastEyeTrackingInerruption() { broadcastEyeTrackingInerruption() }
    }
#endif
