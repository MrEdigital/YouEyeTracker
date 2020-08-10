 # YouEyeTracker
 
![language](https://img.shields.io/badge/language-swift-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/YouEyeTracker.svg?style=flat)](http://cocoapods.org/pods/YouEyeTracker)
![CI Status](https://img.shields.io/badge/build-passing-success.svg)
[![Coverage Status](https://img.shields.io/badge/coverage-98.6%25-success.svg)](https://github.com/MREdigital/YouEyeTracker)
[![Platform](https://img.shields.io/cocoapods/p/YouEyeTracker.svg?style=flat)](http://cocoapods.org/pods/YouEyeTracker)
[![License](https://img.shields.io/cocoapods/l/YouEyeTracker.svg?style=flat)](http://cocoapods.org/pods/YouEyeTracker)
[![Twitter](https://img.shields.io/badge/twitter-@ericreedy-blue.svg)](http://twitter.com/ericreedy)


A library to which an object can subscribe and receive 3D real-world-space eye-tracking position callbacks relative to the position of the front-facing camera.

## Installation

TextFetcher is available through [CocoaPods](http://cocoapods.org). To install, simply add the following line to your Podfile:

```ruby
pod "YouEyeTracker"
```

Run:

`$ pod install`

And remember to add a "Camera Usage Description" to your project's info.plist, so that iOS can prompt the user for access, eg:

    <key>NSCameraUsageDescription</key>
    <string>Your Description Goes Here</key>
    
## Usage

- [Initialization](#Initialization)
- [Configuration](#Configuration)
- [Starting and Stopping](#Starting-and-Stopping)
- [Subscribing](#Subscribing)

## Initialization

The library's primary class is not intended for public initialization, instead providing a singleton accessor:

#### Interface(s):

```swift
public static let shared: YouEyeTracker = .init()
```

#### Example(s):

```swift
YouEyeTracker.shared.doSomething(...)
```

## Configuration

YouEyeTracker is configured with a struct containing two potential parameters.  The first, pointOfView, specifies the point in which the user's perspective calculations should be relative to.  Possible values include `[.leftEye, .rightEye, .eyeAverage]`.  The second, showTrackingInSceneView, (which is primarily intended for debug and demonstration purposes) populates the underlying SceneKit view with Geometry, so that tracking can be visualized should the view be presented.

#### Interface(s):

```swift
public struct Config {
    public init(pointOfView: Config.PointOfView? = nil, showTrackingInSceneView: Bool = false)
}
```

#### Example(s)

```swift
YouEyeTracker.shared.configure(with: Config(pointOfView: .rightEye))
```
    
## Starting and Stopping
    
To start and stop the eye tracking processes of YouEyeTracker, you simply call its `start()` and `stop()` methods.

#### Interface(s)

```swift
public func start()
public func stop()
```

#### Example(s)

```swift
YouEyeTracker.shared.start() // when you're ready for it to start
YouEyeTracker.shared.stop()  // when you're ready for it to stop
```
    
## Subscribing

To get any benefit from YouEyeTracker you need objects which can subscribe to its callbacks.  You do this by conforming any designated class to the EyePositionSubscriber protocol.

#### Interface(s):

```swift
@objc public protocol EyePositionSubscriber: class {
    func eyePositionMovedTo(xPosition: Float, yPosition: Float, zPosition: Float)
    func eyeTrackingInterrupted()
}
```

#### Example(s):

```swift
extension MyClass: EyePositionSubscriber {

    func eyePositionMovedTo(position: float3?) {
        // do stuff
    }

    func eyeTrackingInterrupted() {
        // do other stuff
    }
}
```

Once conformed, you can pass them into its `subscribe(...)` method.

#### Interface(s)

```swift
public func subscribe(_ subscriber: EyePositionSubscriber)
```

#### Example(s)

```swift
YouEyeTracker.shared.subscribe(self)
```

And so long as YouEyeTracker is running the class will receive a steady stream of broadcasts.

## Support

This library should work on any iOS / iPad OS device which supports ARKit Face Tracking.  See ARKit documentation for a comprehensive list of such devices.  (I'm assuming that such a list actually exists somewhere.)

## License

This project is available under [The MPL-2.0 License](https://www.mozilla.org/en-US/MPL/2.0/), with an additional Data Collection and Social Responsibility clause (3.4).  
Copyright © 2020, [Eric Reedy](mailto:eric@madcapstudios.com). See [LICENSE](LICENSE) file.
