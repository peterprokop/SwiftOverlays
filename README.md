![Imgur](http://i.imgur.com/AFMWOiJ.gif)

SwiftOverlays is a Swift GUI library for displaying various popups and notifications.

SwiftOverlays animated logo is kindly made by [Crafted Pixels](http://bit.ly/craftedpx)

[![Build Status](https://travis-ci.org/peterprokop/SwiftOverlays.svg?branch=master)](https://travis-ci.org/peterprokop/SwiftOverlays)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

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

### Carthage
* `> Cartfile`
* `nano Cartfile`
* put `github "peterprokop/SwiftOverlays" ~> 5.0.0` into Cartfile
* Save it: `ctrl-x`, `y`, `enter`
* Run `carthage update`
* Copy `SwiftOverlays.framework` from `Carthage/Build/iOS` to your project
* Make sure that `SwiftOverlays` is added in `Embedded Binaries` section of your target (or else you will get `dyld library not loaded referenced from ... reason image not found` error)
* Add `import SwiftOverlays` on top of your view controller's code

### Cocoapods
- Make sure that you use latest stable Cocoapods version: `pod --version`
- If not, update it: `sudo gem install cocoapods`
- `pod init` in you project root dir
- `nano Podfile`, add:

```
pod 'SwiftOverlays', '~> 5.0.0'
use_frameworks! 
``` 
- Save it: `ctrl-x`, `y`, `enter`
- `pod update`
- Open generated `.xcworkspace`
- Don't forget to import SwiftOverlays: `import SwiftOverlays`!

## Requirements

- iOS 10.0+
- Xcode 10.0+
- Swift 4.2 (if you need older swift version, see
[swift-3.0](https://github.com/peterprokop/SwiftOverlays/tree/swift-3.0) and others)

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
UIViewController.showOnTopOfStatusBar(annoyingNotificationView!, duration: 5)

// Block user interaction
SwiftOverlays.showBlockingWaitOverlayWithText("This is blocking overlay!")

// Don't forget to unblock!
SwiftOverlays.removeAllBlockingOverlays()

```

### Using with UITableViewController/UICollectionViewController

You can't use SwiftOverlays convenience methods directly with UITableViewController - because its view is, well, an UITableView, and overlay will be scrolled along with it.

Instead I suggest using UIViewController instead of UITableViewController and adding UITableView as a subview.
(the same applies to UICollectionViewController)

If for some reason you can't use UIViewController, you can do something like:
```swift
if let superview = self.view.superview {
  SwiftOverlays.showCenteredWaitOverlayWithText(superview, text: "Please wait...")
  SwiftOverlays.removeAllOverlaysFromView(superview)
}
```

(but in that case overlay will be added to the superview, and you should obviously do that only if superview is available - for example in viewDidAppear method of your controller.).

## Contribution

You are welcome to fork and submit pull requests

## Other Projects

- [StarryStars](https://github.com/peterprokop/StarryStars) - iOS GUI library for displaying and editing ratings.
- [AlertyAlert](https://github.com/peterprokop/AlertyAlert) - AlertyAlert is a nice and fluffy iOS alert library for all your alerty needs.
