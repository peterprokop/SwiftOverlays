[![Build Status](https://travis-ci.org/peterprokop/SwiftOverlays.svg?branch=master)](https://travis-ci.org/peterprokop/SwiftOverlays)

# SwiftOverlays

SwiftOverlays is a Swift GUI library for displaying various popups and notifications.


## Features

SwiftOverlays provides several ways to notify user:

- [x] Wait overlay: a simple overlay with activity indicator

![Wait](https://i.imgflip.com/df53v.gif)

- [x] Wait overlay with text 

![WaitWithText](https://i.imgflip.com/df525.gif)

- [x] Overlay with text only
- [x] Overlay with image and text (can be used with [PPSwiftGifs](https://github.com/peterprokop/PPSwiftGifs) to show custom animated GIF instead of UIActivityIndicatorView)
- [x] All of the above with blocking any user interaction
- [x] Notification on top of the status bar, similar to native iOS local/push notifications

![Notification](https://i.imgflip.com/df5k5.gif)

## Installation

### Manual
Just clone and add ```SwiftOverlays.swift``` to your project.

### Cocoapods
- Make sure that your Cocoapods version is >= 0.36: `pod --version`
- If not, update it: `sudo gem install cocoapods`
- `pod init` in you project root dir
- `nano Podfile`, add:

```
pod 'SwiftOverlays', '~> 0.14'
use_frameworks! 
``` 
- Save it: `ctrl-x`, `y`, `enter`
- `pod update`
- Open generated `.xcworkspace`
- Don't forget to import SwiftOverlays: `import SwiftOverlays`!

## Requirements

- iOS 7.0+ (8.0+ if you use Cocoapods)
- Xcode 6.3
- Swift 1.2 (if you need Swift 1.1, use [swift-1.1 branch](https://github.com/peterprokop/SwiftOverlays/tree/swift-1.1))
- For Swift 2.0 use [swift-2.0 branch](https://github.com/peterprokop/SwiftOverlays/tree/swift-2.0)

## Usage

If you're using CocoaPods, import the library with `import SwiftOverlays`

You can use UIViewController convenience methods provided by library:

```swift
// In your view controller:

// Wait overlay
self.showWaitOverlay()

// Wait overlay with text
let text = "Please wait..."
self.showWaitOverlayWithText(text)

// Overlay with text only
let text = "This is a text-only overlay...\n...spanning several lines"
self.showTextOverlay(text)

// Remove everything
self.removeAllOverlays()

// Notification on top of the status bar
UIViewController.showNotificationOnTopOfStatusBar(annoyingNotificationView!, duration: 5)

// Block user interaction
SwiftOverlays.showBlockingWaitOverlayWithText("This is blocking overlay!")

// Don't forget to unblock!
SwiftOverlays.removeAllBlockingOverlays()

```

## Contribution

You are welcome to fork and submit pull requests
