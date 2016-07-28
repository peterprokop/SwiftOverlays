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
        case wait
        case waitWithText
        case textOnly
        case imageAndText
        case progress
        case annoyingNotification
        case blockingWait
        case blockingWaitWithText
    }
    
    @IBOutlet var annoyingNotificationView: UIView?
    
    var type: ExampleType = .wait

    var beginTimer: Timer?
    var endTimer: Timer?
    
    var progress = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.begin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let beginTimer = beginTimer {
            beginTimer.invalidate()
        }
        
        if let endTimer = endTimer {
            endTimer.invalidate()
        }
        
        SwiftOverlays.removeAllBlockingOverlays()
    }
    
    // MARK: begin/end
    func begin() {
        switch (type) {
        case .wait:
            let _ = self.showWaitOverlay()
            // Or SwiftOverlays.showCenteredWaitOverlay(self.view)
            
        case .waitWithText:
            let text = "Please wait..."
            let _ = self.showWaitOverlayWithText(text)
            // Or SwiftOverlays.showCenteredWaitOverlayWithText(self.view, text: text)
        
        case .textOnly:
            let text = "This is a text-only overlay...\n...spanning several lines"
            let _ = self.showTextOverlay(text)
            // Or SwiftOverlays.showTextOverlay(self.view, text: text)
            
            return
            
        case .imageAndText:
            let image = PPSwiftGifs.animatedImageWithGIFNamed("Loading")
            let text = "Overlay\nWith cool GIF!"
            let _ = self.showImageAndTextOverlay(image!, text: text)
            // Or SwiftOverlays.showImageAndTextOverlay(self.view, image: image!, text: text)

            return
            
        case .progress:
            let _ = self.showProgressOverlay("This is a progress overlay!")
            endTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(end), userInfo: nil, repeats: true)
            
            return
            
        case .annoyingNotification:
            Bundle.main.loadNibNamed("AnnoyingNotification", owner: self, options: nil)
            annoyingNotificationView!.frame.size.width = self.view.bounds.width;
            
            UIViewController.showNotificationOnTopOfStatusBar(annoyingNotificationView!, duration: 5)
            // Or SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(annoyingNotificationView!, duration: 5)
            
            return
            
        case .blockingWait:
            let _ = SwiftOverlays.showBlockingWaitOverlay()
            
        case .blockingWaitWithText:
            let _ = SwiftOverlays.showBlockingWaitOverlayWithText("This is blocking overlay!")
        }
        
        if let endTimer = endTimer {
            endTimer.invalidate()
        }
        
        endTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(end), userInfo: nil, repeats: false)
    }
    
    func end() {
        switch (type) {
        case .wait, .waitWithText, .textOnly, .imageAndText:
            SwiftOverlays.removeAllOverlaysFromView(self.view)
            
        case .progress:
            progress += 0.01
            let newProgressValue = Int(100*progress) % 101
            self.updateOverlayProgress(Float(newProgressValue)/100)
            return
            
        case .blockingWait, .blockingWaitWithText:
            SwiftOverlays.removeAllBlockingOverlays()
            
        case .annoyingNotification:
            return
        }
        
        
        if let beginTimer = beginTimer {
            beginTimer.invalidate()
        }
        
        beginTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(begin), userInfo: nil, repeats: false)
    }
}
