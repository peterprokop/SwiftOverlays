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
    func showWaitOverlay() -> UIView {
        return SwiftOverlays.showCenteredWaitOverlay(self.view)
    }
    
    func showWaitOverlayWithText(text: NSString) -> UIView  {
        return SwiftOverlays.showCenteredWaitOverlayWithText(self.view, text: text)
    }
    
    func showTextOverlay(text: NSString) -> UIView  {
        return SwiftOverlays.showTextOverlay(self.view, text: text)
    }
    
    func showImageAndTextOverlay(image: UIImage, text: NSString) -> UIView  {
        return SwiftOverlays.showImageAndTextOverlay(self.view, image: image, text: text)
    }
    
    class func showNotificationOnTopOfStatusBar(notificationView: UIView, duration: NSTimeInterval) {
        SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(notificationView, duration: duration)
    }
    
    func removeAllOverlays() -> Void  {
        SwiftOverlays.removeAllOverlaysFromView(self.view)
    }
}

public class SwiftOverlays: NSObject {
    // Workaround for "Class variables not yet supported"
    // You can customize these values
    struct Statics {
        // Some random number
        static let containerViewTag = 456987123
        
        static let cornerRadius = CGFloat(10)
        static let padding = CGFloat(10)
        
        static let backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        static let textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        static let font = UIFont(name: "HelveticaNeue", size: 14)!
        
        // Annoying notifications on top of status bar
        static let bannerDissapearAnimationDuration = 0.5
    }
    
    private struct PrivateStaticVars {
        static var bannerWindow : UIWindow?
    }
    
    // MARK: Public class methods
    
    public class func showCenteredWaitOverlay(parentView: UIView) -> UIView {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        ai.startAnimating()
        
        let containerViewRect = CGRectMake(0,
            0,
            ai.frame.size.width * 2,
            ai.frame.size.height * 2)
        
        let containerView = UIView(frame: containerViewRect)
        
        containerView.tag = Statics.containerViewTag
        containerView.layer.cornerRadius = Statics.cornerRadius
        containerView.backgroundColor = Statics.backgroundColor
        containerView.center = CGPointMake(parentView.bounds.size.width/2,
            parentView.bounds.size.height/2);
        
        ai.center = CGPointMake(containerView.bounds.size.width/2,
            containerView.bounds.size.height/2);
        
        containerView.addSubview(ai)
        
        parentView.addSubview(containerView)
        
        return containerView
    }
    
    public class func showCenteredWaitOverlayWithText(parentView: UIView, text: NSString) -> UIView  {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        ai.startAnimating()
        
        return showGenericOverlay(parentView, text: text, accessoryView: ai)
    }
    
    public class func showImageAndTextOverlay(parentView: UIView, image: UIImage, text: NSString) -> UIView  {
        let imageView = UIImageView(image: image)
        
        return showGenericOverlay(parentView, text: text, accessoryView: imageView)
    }

    public class func showGenericOverlay(parentView: UIView, text: NSString, accessoryView: UIView) -> UIView {
        let label = labelForText(text)
        label.frame = CGRectOffset(label.frame, accessoryView.frame.size.width + Statics.padding * 2, Statics.padding)
        
        let actualSize = CGSizeMake(accessoryView.frame.size.width + label.frame.size.width + Statics.padding * 3,
            max(label.frame.size.height, accessoryView.frame.size.height) + Statics.padding * 2)
        
        // Container view
        let containerViewRect = CGRectMake(0,
            0,
            actualSize.width,
            actualSize.height)
        
        let containerView = UIView(frame: containerViewRect)
        
        containerView.tag = Statics.containerViewTag
        containerView.layer.cornerRadius = Statics.cornerRadius
        containerView.backgroundColor = Statics.backgroundColor
        containerView.center = CGPointMake(parentView.bounds.size.width/2,
            parentView.bounds.size.height/2);
        
        accessoryView.frame = CGRectOffset(accessoryView.frame, Statics.padding, (actualSize.height - accessoryView.frame.size.height)/2)
        
        containerView.addSubview(accessoryView)
        containerView.addSubview(label)
        
        parentView.addSubview(containerView)
        
        return containerView
    }
    
    public class func showTextOverlay(parentView: UIView, text: NSString) -> UIView  {
        let label = labelForText(text)
        label.frame = CGRectOffset(label.frame, Statics.padding, Statics.padding)
        
        let actualSize = CGSizeMake(label.frame.size.width + Statics.padding * 2,
            label.frame.size.height + Statics.padding * 2)
        
        // Container view
        let containerViewRect = CGRectMake(0,
            0,
            actualSize.width,
            actualSize.height)
        
        let containerView = UIView(frame: containerViewRect)
        
        containerView.tag = Statics.containerViewTag
        containerView.layer.cornerRadius = Statics.cornerRadius
        containerView.backgroundColor = Statics.backgroundColor
        containerView.center = CGPointMake(parentView.bounds.size.width/2,
            parentView.bounds.size.height/2);

        containerView.addSubview(label)
        
        parentView.addSubview(containerView)
        
        return containerView
    }
    
    public class func removeAllOverlaysFromView(parentView: UIView) {
        var overlay: UIView?

        while true {
            overlay = parentView.viewWithTag(Statics.containerViewTag)
            if overlay == nil {
                break
            }
            
            overlay!.removeFromSuperview()
        }
    }
    
    public class func showAnnoyingNotificationOnTopOfStatusBar(notificationView: UIView, duration: NSTimeInterval) {
        if PrivateStaticVars.bannerWindow == nil {
            PrivateStaticVars.bannerWindow = UIWindow()
            PrivateStaticVars.bannerWindow!.windowLevel = UIWindowLevelStatusBar + 1
        }
        
        PrivateStaticVars.bannerWindow!.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, notificationView.frame.size.height)
        PrivateStaticVars.bannerWindow!.hidden = false
        
        let selector = Selector("closeAnnoyingNotificationOnTopOfStatusBar:")
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        notificationView.addGestureRecognizer(gestureRecognizer)
        
        PrivateStaticVars.bannerWindow!.addSubview(notificationView)
        self.performSelector(selector, withObject: notificationView, afterDelay: duration)
    }
    
    public class func closeAnnoyingNotificationOnTopOfStatusBar(sender: AnyObject) {
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
    
        var notificationView: UIView?
        
        if sender.isKindOfClass(UITapGestureRecognizer) {
            notificationView = (sender as! UITapGestureRecognizer).view!
        } else if sender.isKindOfClass(UIView) {
            notificationView = (sender as! UIView)
        }
        
        UIView.animateWithDuration(Statics.bannerDissapearAnimationDuration,
            animations: { () -> Void in
                let frame = notificationView!.frame
                notificationView!.frame = frame.rectByOffsetting(dx: 0, dy: -frame.size.height)
            },
            completion: { (finished) -> Void in
                notificationView!.removeFromSuperview()
                
                PrivateStaticVars.bannerWindow!.hidden = true
            }
        )
    }
    
    // MARK: Private class methods
    
    private class func labelForText(text: NSString) -> UILabel {
        let textSize = text.sizeWithAttributes([NSFontAttributeName: Statics.font])
        
        let labelRect = CGRectMake(0,
            0,
            textSize.width,
            textSize.height)
        
        let label = UILabel(frame: labelRect)
        label.font = Statics.font
        label.textColor = Statics.textColor
        label.text = text as String
        label.numberOfLines = 0
        
        return label;
    }
}