//
//  WaitVC.swift
//  Example
//
//  Created by Peter Prokop on 17/10/14.
//
//

import UIKit

class OverlayExampleVC: UIViewController {
    enum ExampleType {
        case Wait
        case WaitWithText
        case AnnoyingNotification
    }
    
    @IBOutlet var annoyingNotificationView: UIView?
    
    var type: ExampleType = .Wait

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.begin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: begin/end
    func begin() {
        switch (type) {
        case .Wait:
            self.showCenteredWaitOverlay()
            // Or SwiftOverlays.showCenteredWaitOverlay(self.view)
            
        case .WaitWithText:
            self.showCenteredWaitOverlayWithText("Please wait...")            
            // Or SwiftOverlays.showCenteredWaitOverlayWithText(self.view, text: "Please wait...")
            
        case .AnnoyingNotification:
            NSBundle.mainBundle().loadNibNamed("AnnoyingNotification", owner: self, options: nil)
            annoyingNotificationView!.frame.size.width = self.view.bounds.width;
            
            UIViewController.showNotificationOnTopOfStatusBar(annoyingNotificationView!, duration: 5)
            // Or SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(annoyingNotificationView!, duration: 5)
        }
        
        let delay = 2.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

        dispatch_after(time, dispatch_get_main_queue(), {
            [weak self] in
            
            let strongSelf = self
            if strongSelf != nil {
                strongSelf!.end()
            }
        })
    }
    
    func end() {
        switch (type) {
        case .Wait, .WaitWithText:
            SwiftOverlays.removeAllOverlaysFromView(self.view)
            
        case .AnnoyingNotification:
            return
        }
        
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            [weak self] in
            
            let strongSelf = self
            if strongSelf != nil {
                self!.begin()
            }
        })
    }
}