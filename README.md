 # YouEyeTracker

A library through which a user can subscribe to receive 3d real-world-space eye-tracking position callbacks relative to the position of the front-facing camera.

```swift
    public
    extension YouEyeTracker {
       
        // Singleton!  Everyone loves these!  Right?! :D
        public let shared : Self
        
        /// This configures YouEyeTracker using the supplied configuration.
        func configure(with configuration: YouEyeTracker.Config)
        
        /// This starts the eye tracking processes of YouEyeTracker
        func start()
        
        /// This stops the eye tracking processes of YouEyeTracker
        func stop()
        
        /// This allows conforming classes to subscribe to YouEyeTracker for protocol-defined callbacks
        func subscribe(_ subscriber: EyePositionSubscriber)
    }
```

## Installation and use

The extension can be installed using [Cocoapods](https://cocoapods.org/) by adding the below line to your `Podfile`:

    pod 'YouEyeTracker'

To use the library in your code first import it by adding:

    import YouEyeTracker

Also remember to add a "Camera Usage Description" to your project's info.plist, so that iOS can prompt the user for access, eg:

    <key>NSCameraUsageDescription</key>
    <string>Your Description Goes Here</key>

Then, in order to set it up, you're going to need to do the following:

1 - Conform any classes you've designated for callbacks to the EyePositionSubscriber protocol, eg:

    extension MyClass: EyePositionSubscriber {

        func eyePositionMovedTo(position: float3?) {
            // do stuff
        }

        func eyeTrackingInterrupted() {
            // do stuff
        }
    }

2 - Configure YouEyeTracker, eg:

    YouEyeTracker.configure(with: .init(pointOfView: .rightEye))

3 - Subscribe the class object from step 1 to YouEyeTracker, eg:

    YouEyeTracker.subscribe(self)
    
4 - Start YouEyeTracker, eg:

    YouEyeTracker.start()

## Support

This library should work on any iOS / iPad OS device which supports ARKit Face Tracking.  See ARKit documentation for a comprehensive list of such devices.  I'm of course assuming that such a list actually exists.

## Author

eric@madcapstudios.com
