#
#  Be sure to run `pod spec lint YouEyeTracker.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
    spec.name          = "YouEyeTracker"
    spec.version       = "1.0.3"
    spec.summary       = "A library through which a user can subscribe to receive 3D real-world-space eye-tracking position callbacks."
    spec.description   = "YouEyeTracker is a library through which a user can subscribe to receive 3D real-world-space eye-tracking position callbacks relative to the position of the device's front-facing camera."
    spec.homepage      = "https://github.com/MREdigital/YouEyeTracker"
    spec.license       = { :type => "Mozilla Public License Version 2.0", :file => "LICENSE" }
    spec.author        = "Eric Reedy"
    spec.source        = { :git => "https://github.com/MREdigital/YouEyeTracker.git", :tag => "#{spec.version}" }
    spec.source_files  = "YouEyeTracker", "YouEyeTracker/**/*.{swift}"
    spec.exclude_files = "YouEyeTracker/Exclude"
    spec.requires_arc  = true
    spec.swift_version = '5.0'
    spec.ios.deployment_target = "12.0"

end
