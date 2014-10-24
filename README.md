# SwiftOverlays

SwiftOverlays is a Swift GUI library for displaying various popups and notifications.


## Features

Currently SwiftOverlays provides 3 ways to notify user:

- [x] Wait overlay: a simple overlay with activity indicator

![Wait](https://i.imgflip.com/df53v.gif)

- [x] Wait overlay with text 

![WaitWithText](https://i.imgflip.com/df525.gif)

- [x] Overlay with text only
- [x] Notification on top of the status bar, similar to native

![Notification](https://i.imgflip.com/df533.gif)

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
