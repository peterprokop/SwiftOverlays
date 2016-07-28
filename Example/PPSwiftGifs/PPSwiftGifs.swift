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
    class func animatedImageWithGIFNamed(_ name: String!) -> UIImage? {
        let screenScale = Int(UIScreen.main().scale)
        let possibleScales = [1, 2, 3]
        let orderedScales = [screenScale] + possibleScales.filter{$0 != screenScale}
        
        let tmp = orderedScales.map{["@\(String($0))x", "@\(String($0))X"]}
        let orderedSuffixes = tmp.reduce([], combine: +) + [""]

        for suffix in orderedSuffixes {
            if let url = Bundle.main.urlForResource(name + suffix, withExtension: "gif") {
                if let source = CGImageSourceCreateWithURL(url, nil) {
                    return animatedImageWithImageSource(source)
                }
            }
        }
        
        return nil
    }
    
    class func animatedImageWithGIFData(_ data: Data!) -> UIImage? {
        if let source = CGImageSourceCreateWithData(data, nil) {
            return animatedImageWithImageSource(source)
        }
        
        return nil
    }
    
    // MARK: Private
    private class func animatedImageWithImageSource (_ source: CGImageSource) -> UIImage?	{
        let (images, delays) = createImagesAndDelays(source);
        let totalDuration = delays.reduce(0, combine: +)
        let frames = frameArray(images, delays, totalDuration)
        
        // All durations in GIF are in 1/100th of second
        let duration = TimeInterval(Double(totalDuration)/100.0)
        let animation = UIImage.animatedImage(with: frames, duration: duration)

        return animation
    }
    
    private class func createImagesAndDelays(_ source: CGImageSource) -> (Array<CGImage>, Array<Int>) {
        let count = Int(CGImageSourceGetCount(source))
        
        var images = Array<CGImage>()
        var delays = Array<Int>()
        
        for i in 0 ..< count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, [:]) {
                images.append(image)
                delays.append(delayForImageAtIndex(source, UInt(i)))
            }
        }
        
        return (images, delays)
    }
    
    private class func delayForImageAtIndex(_ source: CGImageSource, _ i: UInt) -> Int {
        var delay = 1

        let properties = CGImageSourceCopyPropertiesAtIndex(source, Int(i), [:])
        
        if (properties != nil) {
            let gifDictionaryProperty = unsafeBitCast(kCGImagePropertyGIFDictionary, to: UnsafePointer<Void>.self)
            let gifProperties = CFDictionaryGetValue(properties, gifDictionaryProperty)
            
            if (gifProperties != nil) {
                let gifPropertiesCFD = unsafeBitCast(gifProperties, to: CFDictionary.self)

                let unclampedDelayTimeProperty = unsafeBitCast(kCGImagePropertyGIFUnclampedDelayTime, to: UnsafePointer<Void>.self)
                var number = unsafeBitCast(CFDictionaryGetValue(gifPropertiesCFD, unclampedDelayTimeProperty), to: NSNumber.self);

                if (number.doubleValue == 0) {
                    let delayTimeProperty = unsafeBitCast(kCGImagePropertyGIFDelayTime, to: UnsafePointer<Void>.self)
                    number = unsafeBitCast(CFDictionaryGetValue(gifPropertiesCFD, delayTimeProperty), to: NSNumber.self);
                }

                if (number.doubleValue > 0) {
                    delay = lrint(number.doubleValue * 100);
                }
            }
        }
        
        return delay;
    }

    private class func frameArray(_ images: Array<CGImage>, _ delays: Array<Int>, _ totalDuration: Int) -> [UIImage] {
        let delayGCD = gcd(delays)

        var frames = Array<UIImage>()
        frames.reserveCapacity(images.count)

        for i in 0 ..< images.count {
            let frame = UIImage(cgImage: images[i], scale: UIScreen.main().scale, orientation: .up)
            for _ in 0 ..< delays[i]/delayGCD {
                frames.append(frame)
            }
        }
        
        return frames;
    }
    
    private class func gcd(_ values: Array<Int>) -> Int {
        if values.count == 0 {
            return 1;
        }
        
        var currentGCD = values[0]

        for i in 0 ..< values.count {
            currentGCD = gcd(values[i], currentGCD)
        }
        
        return currentGCD;
    }

    private class func gcd(_ aNumber: Int, _ anotherNumber: Int) -> Int {
        var a = aNumber
        var b = anotherNumber
        while true {
            let r = a % b
            if r == 0 {
                return b
            }
            a = b
            b = r
        }
    }
}
