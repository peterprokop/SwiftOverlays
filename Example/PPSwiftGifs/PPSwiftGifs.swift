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
        let screenScale = Int(UIScreen.main.scale)
        let possibleScales = [1, 2, 3]
        let orderedScales = [screenScale] + possibleScales.filter{$0 != screenScale}
        
        let mapping = { (x: Int) in ["@" + String(x) + "x", "@" + String(x) + "X"]}
        let tmp = orderedScales.map(mapping)
        let orderedSuffixes = tmp.reduce([], +) + [""]

        for suffix in orderedSuffixes {
            if let url = Bundle.main.url(forResource: name + suffix, withExtension: "gif") {
                if let source = CGImageSourceCreateWithURL(url as CFURL, nil) {
                    return animatedImageWithImageSource(source: source)
                }
            }
        }
        
        return nil
    }
    
    class func animatedImageWithGIFData(data: NSData!) -> UIImage? {
        if let source = CGImageSourceCreateWithData(data, nil) {
            return animatedImageWithImageSource(source: source)
        }
        
        return nil
    }
    
    // MARK: Private
    private class func animatedImageWithImageSource (source: CGImageSource) -> UIImage?	{
        let (images, delays) = createImagesAndDelays(source: source);
        let totalDuration = delays.reduce(0, +)
        let frames = frameArray(images, delays, totalDuration)
        
        // All durations in GIF are in 1/100th of second
        let duration = TimeInterval(Double(totalDuration)/100.0)
        let animation = UIImage.animatedImage(with: frames, duration: duration)

        return animation
    }
    
    private class func createImagesAndDelays(source: CGImageSource) -> (Array<CGImage>, Array<Int>) {
        let count = Int(CGImageSourceGetCount(source))
        
        var images = Array<CGImage>()
        var delays = Array<Int>()
        
        for i in 0 ..< count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, [:] as CFDictionary) {
                images.append(image)
                delays.append(delayForImageAtIndex(source, UInt(i)))
            }
        }
        
        return (images, delays)
    }
    
    private class func delayForImageAtIndex(_ source: CGImageSource, _ i: UInt) -> Int {
        var delay = 1

        let properties = CGImageSourceCopyPropertiesAtIndex(source, Int(i), [:] as CFDictionary)
        
        if (properties != nil) {
            let gifDictionaryProperty = unsafeBitCast(kCGImagePropertyGIFDictionary, to: UnsafeRawPointer.self)
            let gifProperties = CFDictionaryGetValue(properties, gifDictionaryProperty)
            
            if (gifProperties != nil) {
                let gifPropertiesCFD = unsafeBitCast(gifProperties, to: CFDictionary.self)

                let unclampedDelayTimeProperty = unsafeBitCast(kCGImagePropertyGIFUnclampedDelayTime, to: UnsafeRawPointer.self)
                var number = unsafeBitCast(CFDictionaryGetValue(gifPropertiesCFD, unclampedDelayTimeProperty), to: NSNumber.self);

                if (number.doubleValue == 0) {
                    let delayTimeProperty = unsafeBitCast(kCGImagePropertyGIFDelayTime, to: UnsafeRawPointer.self)
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
        let delayGCD = gcd(values: delays)

        var frames = Array<UIImage>()
        frames.reserveCapacity(images.count)

        for i in 0 ..< images.count {
            let frame = UIImage(cgImage: images[i], scale: UIScreen.main.scale, orientation: .up)
            for _ in 0 ..< delays[i]/delayGCD {
                frames.append(frame)
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
            currentGCD = gcd(currentGCD, values[i])
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
