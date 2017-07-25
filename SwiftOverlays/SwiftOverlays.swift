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
    
    func showWaitOverlayWithText(_ text: String, withFontSize size: CGFloat) -> UIView {
        return SwiftOverlays.showCenteredWaitOverlayWithText(self.view, text: text, fontSize: size)
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
    
    func showTextOverlay(_ text: String, withFontSize size: CGFloat) -> UIView {
        return SwiftOverlays.showTextOverlay(self.view, text: text, fontSize: size)
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
    Shows overlay *with button and text*, centered in the view controller's main view.

    Do not use this method for **UITableViewController** or **UICollectionViewController**

    - parameter image: Image to be added to overlay
    - parameter text: Text to be shown on overlay
    - parameter horizontalLayout: If the alignment of items inside should be horizontal or vertical
    - parameter showTextFirst: If the text should be on top (for Vertical align) or right (for Horizontal align) of the button

    - returns: A reference to the button
    */
   func showButtonAndTextOverlay(_ image: UIImage, text: String, horizontalLayout: Bool = true, showTextFirst: Bool = false) -> UIButton {
      return SwiftOverlays.showButtonAndTextOverlay(self.view, image, text, horizontalLayout, showTextFirst)
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
        open static func centerViewInSuperview(_ view: UIView) {
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
    
    open class func showCenteredWaitOverlayWithText(_ parentView: UIView, text: String) -> UIView  {
        return showCenteredWaitOverlayWithText(parentView, text: text, fontSize: 14.0)
    }

    @discardableResult
    open class func showCenteredWaitOverlayWithText(_ parentView: UIView, text: String, fontSize: CGFloat) -> UIView  {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)

        ai.startAnimating()
        
        return showGenericOverlay(parentView, text: text, fontSize: fontSize, accessoryView: ai)
    }
    
    @discardableResult
    open class func showImageAndTextOverlay(_ parentView: UIView, image: UIImage, text: String) -> UIView  {
        let imageView = UIImageView(image: image)
        
        return showGenericOverlay(parentView, text: text, accessoryView: imageView)
    }

   @discardableResult
   open class func showButtonAndTextOverlay(_ parentView: UIView, _ image: UIImage, _ text: String, _ horizontalLayout: Bool = true, _ showTextFirst: Bool = false) -> UIButton {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      button.setImage(image, for: .normal)
      button.setImage(image, for: .selected)
      showGenericOverlay(parentView, text, button, horizontalLayout, showTextFirst)
      return button
   }

    open class func showGenericOverlay(_ parentView: UIView, text: String, accessoryView: UIView, horizontalLayout: Bool = true) -> UIView {
        return showGenericOverlay(parentView, text: text, fontSize: 14.0, accessoryView: accessoryView)
    }

   @discardableResult
   open class func showGenericOverlay(_ parentView: UIView, _ text: String, _ fontSize: CGFloat, _ accessoryView: UIView, _ horizontalLayout: Bool = true, _ showTextFirst: Bool = false) -> UIView {

      // Get a full setted label
      let label = labelForText(text)

      // Values to perform position calculations
      var contentSize = CGSize.zero
      let labelWidth = label.frame.size.width
      let labelHeight = label.frame.size.height
      let accWidth = accessoryView.frame.size.width
      let accHeight = accessoryView.frame.size.height

      if horizontalLayout {

         // Calculates parent size
         contentSize = CGSize(width: accWidth + labelWidth + (padding * 3),
                              height: max(labelHeight, accHeight) + (padding * 2))
         let parentHeight = contentSize.height

         if showTextFirst {

            // Place the label on the left
            label.frame = label.frame.offsetBy(dx: padding, dy: (parentHeight - labelHeight)/2)
            accessoryView.frame = accessoryView.frame.offsetBy(dx: labelWidth + padding * 2, dy: (parentHeight - accHeight)/2)

         } else {

            // Place the label on the right
            label.frame = label.frame.offsetBy(dx: accWidth + padding * 2, dy: (parentHeight - labelHeight)/2)
            accessoryView.frame = accessoryView.frame.offsetBy(dx: padding, dy: (parentHeight - accHeight)/2)
         }

      } else { // Vertical

         // Calculates parent size
         contentSize = CGSize(width: max(accWidth, labelWidth) + (padding * 2),
                              height: labelHeight + accHeight + (padding * 3))
         let parentWidth = contentSize.width

         if showTextFirst {

            // Place the label over the accessoryView
            label.frame = label.frame.offsetBy(dx: (parentWidth - labelWidth)/2, dy: padding)
            accessoryView.frame = accessoryView.frame.offsetBy(dx: (parentWidth - accWidth)/2, dy: labelHeight + (padding * 2))

         } else {

            // Place the label below the accessoryView
            label.frame = label.frame.offsetBy(dx: (parentWidth - labelWidth)/2, dy: accHeight + (padding * 2))
            accessoryView.frame = accessoryView.frame.offsetBy(dx: (parentWidth - accWidth)/2, dy: padding)
         }
      }

      // Container view
      let containerViewRect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)

      let containerView = UIView(frame: containerViewRect)
      containerView.tag = containerViewTag
      containerView.layer.cornerRadius = cornerRadius
      containerView.backgroundColor = backgroundColor
      containerView.center = CGPoint(x: parentView.bounds.size.width/2, y: parentView.bounds.size.height/2)
      containerView.addSubview(accessoryView)
      containerView.addSubview(label)
      
      parentView.addSubview(containerView)
      Utils.centerViewInSuperview(containerView)
      
      return containerView
   }
    
    open class func showTextOverlay(_ parentView: UIView, text: String) -> UIView  {
        return showTextOverlay(parentView, text: text, fontSize: 14.0)
    }

    @discardableResult
    open class func showTextOverlay(_ parentView: UIView, text: String, fontSize: CGFloat) -> UIView  {
        let label = labelForText(text, withFontSize: fontSize)
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
    
    open class func showProgressOverlay(_ parentView: UIView, text: String) -> UIView  {
        let pv = UIProgressView(progressViewStyle: .default)
        
        return showGenericOverlay(parentView, text: text, accessoryView: pv, horizontalLayout: false)
    }
    
    open class func removeAllOverlaysFromView(_ parentView: UIView) {
        var overlay: UIView?

        while true {
            overlay = parentView.viewWithTag(containerViewTag)
            if overlay == nil {
                break
            }
            
            overlay!.removeFromSuperview()
        }
    }
    
    open class func updateOverlayText(_ parentView: UIView, text: String) {
        if let overlay = parentView.viewWithTag(containerViewTag) {
            for subview in overlay.subviews {
                if let label = subview as? UILabel {
                    label.text = text as String
                    break
                }
            }
        }
    }
    
    open class func updateOverlayProgress(_ parentView: UIView, progress: Float) {
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
    
    open class func showAnnoyingNotificationOnTopOfStatusBar(_ notificationView: UIView, duration: TimeInterval, animated: Bool = true) {
        if bannerWindow == nil {
            bannerWindow = UIWindow()
            bannerWindow!.windowLevel = UIWindowLevelStatusBar + 1
            bannerWindow!.backgroundColor = UIColor.clear
        }
        
        bannerWindow!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: notificationView.frame.size.height)
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
    
    open class func closeAnnoyingNotificationOnTopOfStatusBar(_ sender: AnyObject) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    
        var notificationView: UIView?
        
        if sender.isKind(of: UITapGestureRecognizer.self) {
            notificationView = (sender as! UITapGestureRecognizer).view!
        } else if sender.isKind(of: UIView.self) {
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
    
    fileprivate class func labelForText(_ text: String) -> UILabel {
        return labelForText(text, withFontSize: 14.0)
    }

    fileprivate class func labelForText(_ text: String, withFontSize size: CGFloat) -> UILabel {
        let font = UIFont.systemFont(ofSize: size)
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
