[![Build Status](https://travis-ci.org/peterprokop/SwiftOverlays.svg?branch=master)](https://travis-ci.org/peterprokop/SwiftOverlays)

# SwiftOverlays

SwiftOverlays is a Swift GUI library for displaying various popups and notifications.


## Features

Currently SwiftOverlays provides 5 ways to notify user:

- [x] Wait overlay: a simple overlay with activity indicator

![Wait](https://i.imgflip.com/df53v.gif)

- [x] Wait overlay with text 

![WaitWithText](https://i.imgflip.com/df525.gif)

- [x] Overlay with text only
- [x] Overlay with image and text (can be used with [PPSwiftGifs](https://github.com/peterprokop/PPSwiftGifs) to show custom animated GIF instead of UIActivityIndicatorView)
- [x] Notification on top of the status bar, similar to native iOS local/push notifications

![Notification](https://i.imgflip.com/df5k5.gif)

## Installation

Just add ```SwiftOverlays.swift``` to your project.

## Requirements

- iOS 7.0+
- Xcode 6.1


## Usage

You can use UIViewController convenience methods provided by library:

```swift
// In your view controller:

self.showWaitOverlay()
// (Wait overlay)

let text = "Please wait..."
self.showWaitOverlayWithText(text)
// (Wait overlay with text)

let text = "This is a text-only overlay...\n...spanning several lines"
self.showTextOverlay(text)
// (Overlay with text only)

UIViewController.showNotificationOnTopOfStatusBar(annoyingNotificationView!, duration: 5)
// (Notification on top of the status bar)
```

## Contribution

You are welcome to fork and submit pull requests
