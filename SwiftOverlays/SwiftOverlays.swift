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
public extension UIViewController {
    
    /**
        Shows wait overlay with activity indicator, centered in the view controller's main view
    
        Do not use this method for **UITableViewController** or **UICollectionViewController**
    
        - returns: Created overlay
    */
    func showWaitOverlay() -> UIView {
        return SwiftOverlays.showCenteredWaitOverlay(self.view)
    }
    
    /**
        Shows wait overlay with activity indicator *and text*, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    func showWaitOverlayWithText(_ text: NSString) -> UIView  {
        return SwiftOverlays.showCenteredWaitOverlayWithText(self.view, text: text)
    }
    
    /**
        Shows *text-only* overlay, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    func showTextOverlay(_ text: NSString) -> UIView  {
        return SwiftOverlays.showTextOverlay(self.view, text: text)
    }
    
    /**
        Shows overlay with text and progress bar, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    func showProgressOverlay(_ text: NSString) -> UIView  {
        return SwiftOverlays.showProgressOverlay(self.view, text: text)
    }
    
    /**
        Shows overlay *with image and text*, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter image: Image to be added to overlay
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    func showImageAndTextOverlay(_ image: UIImage, text: NSString) -> UIView  {
        return SwiftOverlays.showImageAndTextOverlay(self.view, image: image, text: text)
    }
    
    /**
        Shows notification on top of the status bar, similar to native local or remote notifications

        - parameter notificationView: View that will be shown as notification
        - parameter duration: Amount of time until notification disappears
        - parameter animated: Should appearing be animated
    */
    class func showNotificationOnTopOfStatusBar(_ notificationView: UIView, duration: TimeInterval, animated: Bool = true) {
        SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(notificationView, duration: duration, animated: animated)
    }
    
    /**
        Removes all overlays from view controller's main view
    */
    func removeAllOverlays() -> Void  {
        SwiftOverlays.removeAllOverlaysFromView(self.view)
    }
    
    /**
        Updates text on the current overlay.
        Does nothing if no overlay is present.
    
        - parameter text: Text to set
    */
    func updateOverlayText(_ text: NSString) {
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

public class SwiftOverlays: NSObject {
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
    
    public class Utils {
        
        /**
            Adds autolayout constraints to innerView to center it in its superview and fix its size.
            `innerView` should have a superview.
        
            - parameter innerView: View to set constraints on
        */
        public static func centerViewInSuperview(_ view: UIView) {
            assert(view.superview != nil, "`view` should have a superview")
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let constraintH = NSLayoutConstraint(item: view,
                attribute: NSLayoutAttribute.centerX,
                relatedBy: NSLayoutRelation.equal,
                toItem: view.superview,
                attribute: NSLayoutAttribute.centerX,
                multiplier: 1,
                constant: 0)
            let constraintV = NSLayoutConstraint(item: view,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: view.superview,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1,
                constant: 0)
            let constraintWidth = NSLayoutConstraint(item: view,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1,
                constant: view.frame.size.width)
            let constraintHeight = NSLayoutConstraint(item: view,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1,
                constant: view.frame.size.height)
            view.superview!.addConstraints([constraintV, constraintH, constraintWidth, constraintHeight])
        }
    }
    
    // MARK: - Public class methods -
    
    // MARK: Blocking
    
    /**
        Shows *blocking* wait overlay with activity indicator, centered in the app's main window
    
        - returns: Created overlay
    */
    public class func showBlockingWaitOverlay() -> UIView {
        let blocker = addMainWindowBlocker()
        let _ = showCenteredWaitOverlay(blocker)
        
        return blocker
    }
    
    /**
        Shows wait overlay with activity indicator *and text*, centered in the app's main window
    
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    public class func showBlockingWaitOverlayWithText(_ text: NSString) -> UIView {
        let blocker = addMainWindowBlocker()
        let _ = showCenteredWaitOverlayWithText(blocker, text: text)
        
        return blocker
    }
    
    /**
        Shows *blocking* overlay *with image and text*,, centered in the app's main window
    
        - parameter image: Image to be added to overlay
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    public class func showBlockingImageAndTextOverlay(_ image: UIImage, text: NSString) -> UIView  {
        let blocker = addMainWindowBlocker()
        let _ = showImageAndTextOverlay(blocker, image: image, text: text)
        
        return blocker
    }
    
    /**
        Shows *text-only* overlay, centered in the app's main window
    
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    public class func showBlockingTextOverlay(_ text: NSString) -> UIView  {
        let blocker = addMainWindowBlocker()
        let _ = showTextOverlay(blocker, text: text)
        
        return blocker
    }
    
    /**
        Removes all *blocking* overlays from application's main window
    */
    public class func removeAllBlockingOverlays() {
        let window = UIApplication.shared().delegate!.window!!
        removeAllOverlaysFromView(window)
    }
    
    // MARK: Non-blocking
    
    public class func showCenteredWaitOverlay(_ parentView: UIView) -> UIView {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ai.startAnimating()
        
        let containerViewRect = CGRect(x: 0,
            y: 0,
            width: ai.frame.size.width * 2,
            height: ai.frame.size.height * 2)
        
        let containerView = UIView(frame: containerViewRect)
        
        containerView.tag = containerViewTag
        containerView.layer.cornerRadius = cornerRadius
        containerView.backgroundColor = backgroundColor
        containerView.center = CGPoint(x: parentView.bounds.size.width/2,
            y: parentView.bounds.size.height/2);
        
        ai.center = CGPoint(x: containerView.bounds.size.width/2,
            y: containerView.bounds.size.height/2);
        
        containerView.addSubview(ai)
        
        parentView.addSubview(containerView)
        
        Utils.centerViewInSuperview(containerView)
        
        return containerView
    }
    
    public class func showCenteredWaitOverlayWithText(_ parentView: UIView, text: NSString) -> UIView  {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        ai.startAnimating()
        
        return showGenericOverlay(parentView, text: text, accessoryView: ai)
    }
    
    public class func showImageAndTextOverlay(_ parentView: UIView, image: UIImage, text: NSString) -> UIView  {
        let imageView = UIImageView(image: image)
        
        return showGenericOverlay(parentView, text: text, accessoryView: imageView)
    }

    public class func showGenericOverlay(_ parentView: UIView, text: NSString, accessoryView: UIView, horizontalLayout: Bool = true) -> UIView {
        let label = labelForText(text)
        var actualSize = CGSize.zero
        
        if horizontalLayout {
            actualSize = CGSize(width: accessoryView.frame.size.width + label.frame.size.width + padding * 3,
                height: max(label.frame.size.height, accessoryView.frame.size.height) + padding * 2)
            
             label.frame = label.frame.offsetBy(dx: accessoryView.frame.size.width + padding * 2, dy: padding)
            
            accessoryView.frame.offsetInPlace(dx: padding, dy: (actualSize.height - accessoryView.frame.size.height)/2)
        } else {
            actualSize = CGSize(width: max(accessoryView.frame.size.width, label.frame.size.width) + padding * 2,
                height: label.frame.size.height + accessoryView.frame.size.height + padding * 3)
            
            label.frame = label.frame.offsetBy(dx: padding, dy: accessoryView.frame.size.height + padding * 2)
            
            accessoryView.frame.offsetInPlace(dx: (actualSize.width - accessoryView.frame.size.width)/2, dy: padding)
        }
        
        // Container view
        let containerViewRect = CGRect(x: 0,
            y: 0,
            width: actualSize.width,
            height: actualSize.height)
        
        let containerView = UIView(frame: containerViewRect)
     
        containerView.tag = containerViewTag
        containerView.layer.cornerRadius = cornerRadius
        containerView.backgroundColor = backgroundColor
        containerView.center = CGPoint(x: parentView.bounds.size.width/2,
            y: parentView.bounds.size.height/2)
        
        containerView.addSubview(accessoryView)
        containerView.addSubview(label)
        
        parentView.addSubview(containerView)
        
        Utils.centerViewInSuperview(containerView)

        return containerView
    }
    
    public class func showTextOverlay(_ parentView: UIView, text: NSString) -> UIView  {
        let label = labelForText(text)
        label.frame = label.frame.offsetBy(dx: padding, dy: padding)
        
        let actualSize = CGSize(width: label.frame.size.width + padding * 2,
            height: label.frame.size.height + padding * 2)
        
        // Container view
        let containerViewRect = CGRect(x: 0,
            y: 0,
            width: actualSize.width,
            height: actualSize.height)
        
        let containerView = UIView(frame: containerViewRect)
        
        containerView.tag = containerViewTag
        containerView.layer.cornerRadius = cornerRadius
        containerView.backgroundColor = backgroundColor
        containerView.center = CGPoint(x: parentView.bounds.size.width/2,
            y: parentView.bounds.size.height/2);

        containerView.addSubview(label)
        
        parentView.addSubview(containerView)
        
        Utils.centerViewInSuperview(containerView)
        
        
        return containerView
    }
    
    public class func showProgressOverlay(_ parentView: UIView, text: NSString) -> UIView  {
        let pv = UIProgressView(progressViewStyle: .default)
        
        return showGenericOverlay(parentView, text: text, accessoryView: pv, horizontalLayout: false)
    }
    
    public class func removeAllOverlaysFromView(_ parentView: UIView) {
        var overlay: UIView?

        while true {
            overlay = parentView.viewWithTag(containerViewTag)
            if overlay == nil {
                break
            }
            
            overlay!.removeFromSuperview()
        }
    }
    
    public class func updateOverlayText(_ parentView: UIView, text: NSString) {
        if let overlay = parentView.viewWithTag(containerViewTag) {
            for subview in overlay.subviews {
                if let label = subview as? UILabel {
                    label.text = text as String
                    break
                }
            }
        }
    }
    
    public class func updateOverlayProgress(_ parentView: UIView, progress: Float) {
        if let overlay = parentView.viewWithTag(containerViewTag) {
            for subview in overlay.subviews {
                if let pv = subview as? UIProgressView {
                    pv.progress = progress
                    break
                }
            }
        }
    }
    
    // MARK: Status bar notification
    
    public class func showAnnoyingNotificationOnTopOfStatusBar(_ notificationView: UIView, duration: TimeInterval, animated: Bool = true) {
        if bannerWindow == nil {
            bannerWindow = UIWindow()
            bannerWindow!.windowLevel = UIWindowLevelStatusBar + 1
            bannerWindow!.backgroundColor = UIColor.clear()
        }
        
        bannerWindow!.frame = CGRect(x: 0, y: 0, width: UIScreen.main().bounds.size.width, height: notificationView.frame.size.height)
        bannerWindow!.isHidden = false
        
        let selector = #selector(closeAnnoyingNotificationOnTopOfStatusBar)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        notificationView.addGestureRecognizer(gestureRecognizer)
        
        bannerWindow!.addSubview(notificationView)
        
        if animated {
            let frame = notificationView.frame
            let origin = CGPoint(x: 0, y: -frame.height)
            notificationView.frame = CGRect(origin: origin, size: frame.size)
            
            // Show appearing animation, schedule calling closing selector after completed
            UIView.animate(withDuration: bannerDissapearAnimationDuration, animations: { 
                let frame = notificationView.frame
                notificationView.frame = frame.offsetBy(dx: 0, dy: frame.height)
            }, completion: { (finished) in
                self.perform(selector, with: notificationView, afterDelay: duration)
            })
        } else {
            // Schedule calling closing selector right away
            self.perform(selector, with: notificationView, afterDelay: duration)
        }
    }
    
    public class func closeAnnoyingNotificationOnTopOfStatusBar(_ sender: AnyObject) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    
        var notificationView: UIView?
        
        if sender is UITapGestureRecognizer {
            notificationView = (sender as! UITapGestureRecognizer).view!
        } else if sender is UIView {
            notificationView = (sender as! UIView)
        }
        
        UIView.animate(withDuration: bannerDissapearAnimationDuration,
            animations: { () -> Void in
                if let frame = notificationView?.frame {
                    notificationView?.frame = frame.offsetBy(dx: 0, dy: -frame.size.height)
                }
            },
            completion: { (finished) -> Void in
                notificationView?.removeFromSuperview()
                
                bannerWindow?.isHidden = true
            }
        )
    }
    
    // MARK: - Private class methods -
    
    private class func labelForText(_ text: NSString) -> UILabel {
        let textSize = text.size(attributes: [NSFontAttributeName: font])
        
        let labelRect = CGRect(x: 0,
            y: 0,
            width: textSize.width,
            height: textSize.height)
        
        let label = UILabel(frame: labelRect)
        label.font = font
        label.textColor = textColor
        label.text = text as String
        label.numberOfLines = 0
        
        return label;
    }
    
    private class func addMainWindowBlocker() -> UIView {
        let window = UIApplication.shared().delegate!.window!!
        
        let blocker = UIView(frame: window.bounds)
        blocker.backgroundColor = backgroundColor
        blocker.tag = containerViewTag
        
        blocker.translatesAutoresizingMaskIntoConstraints = false

        window.addSubview(blocker)
        
        let viewsDictionary = ["blocker": blocker]
        
        // Add constraints to handle orientation change
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[blocker]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[blocker]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        
        window.addConstraints(constraintsV + constraintsH)
        
        return blocker
    }
}
