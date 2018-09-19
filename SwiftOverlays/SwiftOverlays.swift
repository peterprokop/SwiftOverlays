//
//  SwiftOverlays.swift
//  SwiftTest
//
//  Created by Peter Prokop on 15/10/14.
//  Copyright (c) 2014 Peter Prokop. All rights reserved.
//

import Foundation
import UIKit


// For convenience methods
@objc public extension UIViewController {
    
    /**
        Shows wait overlay with activity indicator, centered in the view controller's main view
    
        Do not use this method for **UITableViewController** or **UICollectionViewController**
    
        - returns: Created overlay
    */
    @discardableResult
    func showWaitOverlay() -> UIView {
        return SwiftOverlays.showCenteredWaitOverlay(self.view)
    }
    
    /**
        Shows wait overlay with activity indicator *and text*, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    @discardableResult
    func showWaitOverlayWithText(_ text: String) -> UIView  {
        return SwiftOverlays.showCenteredWaitOverlayWithText(self.view, text: text)
    }
    
    /**
        Shows *text-only* overlay, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    @discardableResult
    func showTextOverlay(_ text: String) -> UIView  {
        return SwiftOverlays.showTextOverlay(self.view, text: text)
    }
    
    /**
        Shows overlay with text and progress bar, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    @discardableResult
    func showProgressOverlay(_ text: String) -> UIView  {
        return SwiftOverlays.showProgressOverlay(self.view, text: text)
    }
    
    /**
        Shows overlay *with image and text*, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter image: Image to be added to overlay
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    @discardableResult
    func showImageAndTextOverlay(_ image: UIImage, text: String) -> UIView  {
        return SwiftOverlays.showImageAndTextOverlay(self.view, image: image, text: text)
    }
    
    /**
        Shows notification on top of the status bar, similar to native local or remote notifications

        - parameter notificationView: View that will be shown as notification
        - parameter duration: Amount of time until notification disappears
        - parameter animated: Should appearing be animated
    */
    class func showOnTopOfStatusBar(_ notificationView: UIView, duration: TimeInterval, animated: Bool = true) {
        SwiftOverlays.showOnTopOfStatusBar(notificationView, duration: duration, animated: animated)
    }
    
    /**
        Removes all overlays from view controller's main view
    */
    func removeAllOverlays() {
        SwiftOverlays.removeAllOverlaysFromView(self.view)
    }
    
    /**
        Updates text on the current overlay.
        Does nothing if no overlay is present.
    
        - parameter text: Text to set
    */
    func updateOverlayText(_ text: String) {
        SwiftOverlays.updateOverlayText(self.view, text: text)
    }
    
    /**
        Updates progress on the current overlay.
        Does nothing if no overlay is present.
    
        - parameter progress: Progress to set 0.0 .. 1.0
    */
    func updateOverlayProgress(_ progress: Float) {
        SwiftOverlays.updateOverlayProgress(self.view, progress: progress)
    }
}

open class SwiftOverlays: NSObject {
    // You can customize these values

    // Some random number
    static let containerViewTag = 456987123
    
    static let cornerRadius = CGFloat(10)
    static let padding = CGFloat(10)
    
    static let backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    static let textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let font = UIFont.systemFont(ofSize: 14)
    
    // Annoying notifications on top of status bar
    static let bannerDissapearAnimationDuration = 0.5

    static var bannerWindow : UIWindow?
    
    open class Utils {
        
        /**
            Adds autolayout constraints to innerView to center it in its superview and fix its size.
            `innerView` should have a superview.
        
            - parameter innerView: View to set constraints on
        */
        public static func centerViewInSuperview(_ view: UIView) {
            assert(view.superview != nil, "`view` should have a superview")
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let constraintH = NSLayoutConstraint(
                item: view,
                attribute: NSLayoutConstraint.Attribute.centerX,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: view.superview,
                attribute: NSLayoutConstraint.Attribute.centerX,
                multiplier: 1,
                constant: 0
            )
            let constraintV = NSLayoutConstraint(
                item: view,
                attribute: NSLayoutConstraint.Attribute.centerY,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: view.superview,
                attribute: NSLayoutConstraint.Attribute.centerY,
                multiplier: 1,
                constant: 0
            )
            let constraintWidth = NSLayoutConstraint(
                item: view,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: nil,
                attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                multiplier: 1,
                constant: view.frame.size.width
            )
            let constraintHeight = NSLayoutConstraint(
                item: view,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: nil,
                attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                multiplier: 1,
                constant: view.frame.size.height
            )
            view.superview!.addConstraints([constraintV, constraintH, constraintWidth, constraintHeight])
        }
    }
    
    // MARK: - Public class methods -
    
    // MARK: Blocking
    
    /**
        Shows *blocking* wait overlay with activity indicator, centered in the app's main window
    
        - returns: Created overlay
    */
    @discardableResult
    open class func showBlockingWaitOverlay() -> UIView {
        let blocker = addMainWindowBlocker()
        showCenteredWaitOverlay(blocker)
        
        return blocker
    }
    
    /**
        Shows wait overlay with activity indicator *and text*, centered in the app's main window
    
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    @discardableResult
    open class func showBlockingWaitOverlayWithText(_ text: String) -> UIView {
        let blocker = addMainWindowBlocker()
        showCenteredWaitOverlayWithText(blocker, text: text)
        
        return blocker
    }
    
    /**
        Shows *blocking* overlay *with image and text*,, centered in the app's main window
    
        - parameter image: Image to be added to overlay
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    open class func showBlockingImageAndTextOverlay(_ image: UIImage, text: String) -> UIView  {
        let blocker = addMainWindowBlocker()
        showImageAndTextOverlay(blocker, image: image, text: text)
        
        return blocker
    }
    
    /**
        Shows *text-only* overlay, centered in the app's main window
    
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    open class func showBlockingTextOverlay(_ text: String) -> UIView  {
        let blocker = addMainWindowBlocker()
        showTextOverlay(blocker, text: text)
        
        return blocker
    }
    
    /**
        Removes all *blocking* overlays from application's main window
    */
    open class func removeAllBlockingOverlays() {
        let window = UIApplication.shared.delegate!.window!!
        removeAllOverlaysFromView(window)
    }
    
    // MARK: Non-blocking
    @discardableResult
    open class func showCenteredWaitOverlay(_ parentView: UIView) -> UIView {
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.startAnimating()
        
        let containerViewRect = CGRect(
            x: 0,
            y: 0,
            width: ai.frame.size.width * 2,
            height: ai.frame.size.height * 2
        )
        
        let containerView = UIView(frame: containerViewRect)
        
        containerView.tag = containerViewTag
        containerView.layer.cornerRadius = cornerRadius
        containerView.backgroundColor = backgroundColor
        containerView.center = CGPoint(
            x: parentView.bounds.size.width/2,
            y: parentView.bounds.size.height/2
        )
        
        ai.center = CGPoint(
            x: containerView.bounds.size.width/2,
            y: containerView.bounds.size.height/2
        )
        
        containerView.addSubview(ai)
        
        parentView.addSubview(containerView)
        
        Utils.centerViewInSuperview(containerView)
        
        return containerView
    }
    
    @discardableResult
    open class func showCenteredWaitOverlayWithText(_ parentView: UIView, text: String) -> UIView  {
        let ai = UIActivityIndicatorView(style: .white)
        ai.startAnimating()
        
        return showGenericOverlay(parentView, text: text, accessoryView: ai)
    }
    
    @discardableResult
    open class func showImageAndTextOverlay(_ parentView: UIView, image: UIImage, text: String) -> UIView  {
        let imageView = UIImageView(image: image)
        
        return showGenericOverlay(parentView, text: text, accessoryView: imageView)
    }

    open class func showGenericOverlay(_ parentView: UIView, text: String, accessoryView: UIView, horizontalLayout: Bool = true) -> UIView {
        let label = labelForText(text)
        var actualSize = CGSize.zero
        
        if horizontalLayout {
            actualSize = CGSize(width: accessoryView.frame.size.width + label.frame.size.width + padding * 3,
                height: max(label.frame.size.height, accessoryView.frame.size.height) + padding * 2)
            
            label.frame = label.frame.offsetBy(dx: accessoryView.frame.size.width + padding * 2, dy: padding)
            
            accessoryView.frame = accessoryView.frame.offsetBy(dx: padding, dy: (actualSize.height - accessoryView.frame.size.height)/2)
        } else {
            actualSize = CGSize(width: max(accessoryView.frame.size.width, label.frame.size.width) + padding * 2,
                height: label.frame.size.height + accessoryView.frame.size.height + padding * 3)
            
            label.frame = label.frame.offsetBy(dx: padding, dy: accessoryView.frame.size.height + padding * 2)
            
            accessoryView.frame = accessoryView.frame.offsetBy(dx: (actualSize.width - accessoryView.frame.size.width)/2, dy: padding)
        }
        
        // Container view
        let containerViewRect = CGRect(origin: .zero, size: actualSize)
        let containerView = UIView(frame: containerViewRect)
     
        containerView.tag = containerViewTag
        containerView.layer.cornerRadius = cornerRadius
        containerView.backgroundColor = backgroundColor
        containerView.center = CGPoint(
            x: parentView.bounds.size.width/2,
            y: parentView.bounds.size.height/2
        )
        
        containerView.addSubview(accessoryView)
        containerView.addSubview(label)
        
        parentView.addSubview(containerView)
        
        Utils.centerViewInSuperview(containerView)

        return containerView
    }
    
    @discardableResult
    open class func showTextOverlay(_ parentView: UIView, text: String) -> UIView  {
        let label = labelForText(text)
        label.frame = label.frame.offsetBy(dx: padding, dy: padding)
        
        let actualSize = CGSize(width: label.frame.size.width + padding * 2,
            height: label.frame.size.height + padding * 2)
        
        // Container view
        let containerViewRect = CGRect(origin: .zero, size: actualSize)
        let containerView = UIView(frame: containerViewRect)
        
        containerView.tag = containerViewTag
        containerView.layer.cornerRadius = cornerRadius
        containerView.backgroundColor = backgroundColor
        containerView.center = CGPoint(
            x: parentView.bounds.size.width/2,
            y: parentView.bounds.size.height/2
        )

        containerView.addSubview(label)
        
        parentView.addSubview(containerView)
        
        Utils.centerViewInSuperview(containerView)

        return containerView
    }
    
    open class func showProgressOverlay(_ parentView: UIView, text: String) -> UIView  {
        let pv = UIProgressView(progressViewStyle: .default)
        
        return showGenericOverlay(parentView, text: text, accessoryView: pv, horizontalLayout: false)
    }
    
    open class func removeAllOverlaysFromView(_ parentView: UIView) {
        parentView.subviews
            .filter { $0.tag == containerViewTag }
            .forEach { $0.removeFromSuperview() }
    }
    
    open class func updateOverlayText(_ parentView: UIView, text: String) {
        if let overlay = parentView.viewWithTag(containerViewTag) {
            overlay.subviews.compactMap { $0 as? UILabel }.first?.text = text
        }
    }
    
    open class func updateOverlayProgress(_ parentView: UIView, progress: Float) {
        if let overlay = parentView.viewWithTag(containerViewTag) {
            overlay.subviews.compactMap { $0 as? UIProgressView }.first?.progress = progress
        }
    }
    
    // MARK: Status bar notification
    
    open class func showOnTopOfStatusBar(_ notificationView: UIView, duration: TimeInterval, animated: Bool = true) {
        if bannerWindow == nil {
            bannerWindow = UIWindow()
            bannerWindow!.windowLevel = UIWindow.Level.statusBar + 1
            bannerWindow!.backgroundColor = UIColor.clear
        }

        // TODO: use autolayout instead
        // Ugly, but works
        let topHeight = UIApplication.shared.statusBarFrame.size.height
            + UINavigationController().navigationBar.frame.height

        let height = max(topHeight, 64)
        let width = UIScreen.main.bounds.width

        let frame = CGRect(x: 0, y: 0, width: width, height: height)

        bannerWindow!.frame = frame
        bannerWindow!.isHidden = false
        
        let selector = #selector(closeNotificationOnTopOfStatusBar)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        notificationView.addGestureRecognizer(gestureRecognizer)
        
        bannerWindow!.addSubview(notificationView)

        if animated {
            notificationView.frame = frame.offsetBy(dx: 0, dy: -frame.height)
            bannerWindow!.layoutIfNeeded()

            // Show appearing animation, schedule calling closing selector after completed
            UIView.animate(withDuration: bannerDissapearAnimationDuration, animations: { 
                let frame = notificationView.frame
                notificationView.frame = frame.offsetBy(dx: 0, dy: frame.height)
            }, completion: { (finished) in
                self.perform(selector, with: notificationView, afterDelay: duration)
            })
        } else {
            notificationView.frame = frame
            // Schedule calling closing selector right away
            self.perform(selector, with: notificationView, afterDelay: duration)
        }
    }
    
    @objc open class func closeNotificationOnTopOfStatusBar(_ sender: AnyObject) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    
        let notificationView: UIView
        
        if let recognizer = sender as? UITapGestureRecognizer {
            notificationView = recognizer.view!
        } else if let view = sender as? UIView {
            notificationView = view
        } else {
            return
        }
        
        UIView.animate(withDuration: bannerDissapearAnimationDuration,
            animations: { () -> Void in
                let frame = notificationView.frame
                notificationView.frame = frame.offsetBy(dx: 0, dy: -frame.height)
            },
            completion: { (finished) -> Void in
                notificationView.removeFromSuperview()
                bannerWindow?.isHidden = true
            }
        )
    }
    
    // MARK: - Private class methods -
    
    fileprivate class func labelForText(_ text: String) -> UILabel {
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        let labelRect = CGRect(origin: .zero, size: textSize)

        let label = UILabel(frame: labelRect)
        label.font = font
        label.textColor = textColor
        label.text = text
        label.numberOfLines = 0
        
        return label
    }
    
    fileprivate class func addMainWindowBlocker() -> UIView {
        let window = UIApplication.shared.delegate!.window!!
        
        let blocker = UIView(frame: window.bounds)
        blocker.backgroundColor = backgroundColor
        blocker.tag = containerViewTag
        
        blocker.translatesAutoresizingMaskIntoConstraints = false

        window.addSubview(blocker)
        
        let viewsDictionary = ["blocker": blocker]
        
        // Add constraints to handle orientation change
        let constraintsV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[blocker]-0-|",
            options: [],
            metrics: nil,
            views: viewsDictionary
        )
        
        let constraintsH = NSLayoutConstraint.constraints(
            withVisualFormat: "|-0-[blocker]-0-|",
            options: [],
            metrics: nil,
            views: viewsDictionary
        )
        
        window.addConstraints(constraintsV + constraintsH)
        
        return blocker
    }
}
