//
//  PPSwiftGifs.swift
//  PPSwiftGifsExample
//
//  Created by Peter Prokop on 08/11/14.
//  Copyright (c) 2014 Peter Prokop. All rights reserved.
//

import Foundation
import UIKit
import CoreFoundation

class PPSwiftGifs
{
    // MARK: Public
    class func animatedImageWithGIFNamed(name: String!) -> UIImage? {
        let screenScale = Int(UIScreen.mainScreen().scale)
        let possibleScales = [1, 2, 3]
        let orderedScales = [screenScale] + possibleScales.filter{$0 != screenScale}
        
        let tmp = orderedScales.map{["@" + String($0) + "x", "@" + String($0) + "X"]}
        let orderedSuffixes = tmp.reduce([], combine: +) + [""]

        for suffix in orderedSuffixes {
            if let url = NSBundle.mainBundle().URLForResource(name + suffix, withExtension: "gif") {
                let source = CGImageSourceCreateWithURL(url, nil)
                
                return animatedImageWithImageSource(source)
            }
        }
        
        return nil
    }
    
    class func animatedImageWithGIFData(data: NSData!) -> UIImage? {
        if let source = CGImageSourceCreateWithData(data, nil) {
            return animatedImageWithImageSource(source)
        }
        
        return nil
    }
    
    // MARK: Private
    private class func animatedImageWithImageSource (source: CGImageSourceRef) -> UIImage?	{
        let (images, delays) = createImagesAndDelays(source);
        let totalDuration = delays.reduce(0, combine: +)
        let frames = frameArray(images, delays, totalDuration)
        
        // All durations in GIF are in 1/100th of second
        let duration = NSTimeInterval(Double(totalDuration)/100.0)
        let animation = UIImage.animatedImageWithImages(frames, duration: duration)

        return animation
    }
    
    private class func createImagesAndDelays(source: CGImageSourceRef) -> (Array<CGImageRef>, Array<Int>) {
        let count = Int(CGImageSourceGetCount(source))
        
        var images = Array<CGImageRef>()
        var delays = Array<Int>()
        
        for i in 0 ..< count {
            images.append(CGImageSourceCreateImageAtIndex(source, UInt(i), nil))
            delays.append(delayForImageAtIndex(source, UInt(i)))
        }
        
        return (images, delays)
    }
    
    private class func delayForImageAtIndex(source: CGImageSourceRef, _ i: UInt) -> Int {
        var delay = 1

        let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil)
        
        if (properties != nil) {
            let gifDictionaryProperty = unsafeBitCast(kCGImagePropertyGIFDictionary, UnsafePointer<Void>.self)
            let gifProperties = CFDictionaryGetValue(properties, gifDictionaryProperty)
            
            if (gifProperties != nil) {
                let gifPropertiesCFD = unsafeBitCast(gifProperties, CFDictionary.self)

                let unclampedDelayTimeProperty = unsafeBitCast(kCGImagePropertyGIFUnclampedDelayTime, UnsafePointer<Void>.self)
                var number = unsafeBitCast(CFDictionaryGetValue(gifPropertiesCFD, unclampedDelayTimeProperty), NSNumber.self);

                if (number.doubleValue == 0) {
                    let delayTimeProperty = unsafeBitCast(kCGImagePropertyGIFDelayTime, UnsafePointer<Void>.self)
                    number = unsafeBitCast(CFDictionaryGetValue(gifPropertiesCFD, delayTimeProperty), NSNumber.self);
                }

                if (number.doubleValue > 0) {
                    delay = lrint(number.doubleValue * 100);
                }
            }
        }
        
        return delay;
    }

    private class func frameArray(images: Array<CGImageRef>, _ delays: Array<Int>, _ totalDuration: Int) -> Array<AnyObject> {
        let delayGCD = gcd(delays)
        let frameCount = totalDuration / delayGCD
        var frames = Array<UIImage>()
        frames.reserveCapacity(images.count)

        for i in 0 ..< images.count {
            let frame = UIImage(CGImage: images[i], scale: UIScreen.mainScreen().scale, orientation: .Up)
            for j in 0 ..< delays[i]/delayGCD {
                frames.append(frame!)
            }
        }
        
        return frames;
    }
    
    private class func gcd(values: Array<Int>) -> Int {
        if values.count == 0 {
            return 1;
        }
        
        var currentGCD = values[0]

        for i in 0 ..< values.count {
            currentGCD = gcd(values[i], currentGCD)
        }
        
        return currentGCD;
    }

    private class func gcd(var a: Int, var _ b: Int) -> Int {
        while (true) {
            var r = a % b
            if (r == 0) {
                return b
            }
            a = b;
            b = r;
        }
    }
}
