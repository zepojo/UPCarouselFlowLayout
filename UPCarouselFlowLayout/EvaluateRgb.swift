//
//  EvaluateRgb.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Mohsen khodadadzadeh on 10/20/19.
//  Copyright © 2019 Paul Ulric. All rights reserved.
//

import UIKit

class EvaluateRGB {
    
    public static func evaluate( fraction: CGFloat, startValue: UIColor, endValue: UIColor) -> UIColor {
        var startInt: Int = startValue.toInt()
        let startA: CGFloat = CGFloat((startInt >> 24) & 0xff) / 255.0
        var startR: CGFloat = CGFloat((startInt >> 16) & 0xff) / 255.0
        var startG: CGFloat = CGFloat((startInt >>  8) & 0xff) / 255.0
        var startB: CGFloat = CGFloat( startInt        & 0xff) / 255.0
        
        let endInt: Int = endValue.toInt()
        let endA: CGFloat = CGFloat((endInt >> 24) & 0xff) / 255.0
        var endR: CGFloat = CGFloat((endInt >> 16) & 0xff) / 255.0
        var endG: CGFloat = CGFloat((endInt >>  8) & 0xff) / 255.0
        var endB: CGFloat = CGFloat( endInt        & 0xff) / 255.0
        
        // convert from sRGB to linear
        startR =  CGFloat(pow(startR, 2.2))
        startG = CGFloat(pow(startG, 2.2))
        startB = CGFloat(pow(startB, 2.2))
        
        endR = CGFloat(pow(endR, 2.2))
        endG = CGFloat(pow(endG, 2.2))
        endB = CGFloat(pow(endB, 2.2))
        
        // compute the interpolated color in linear space
        var a: CGFloat = startA + fraction * (endA - startA)
        var r: CGFloat = startR + fraction * (endR - startR)
        var g: CGFloat = startG + fraction * (endG - startG)
        var b: CGFloat = startB + fraction * (endB - startB)
        
        // convert back to sRGB in the [0..255] range
        a = a * 255.0
        r = CGFloat(pow(r, 1.0 / 2.2) * 255.0)
        g = CGFloat(pow(g, 1.0 / 2.2) * 255.0)
        b = CGFloat(pow(b, 1.0 / 2.2) * 255.0)
        let int1 = Int(round(a)) << 24
        let int2 = Int(round(r)) << 16
        let int3 = Int(round(g)) << 8
        let int4 = Int(round(b))
        let intObject = int1 | int2 | int3 | int4
        return UIColor(rgb: intObject)
    }
}

extension UIColor {
    func toInt() -> Int {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return rgb
        //return NSString(format:"%06x", rgb) as String
    }
    
    convenience init(rgb: Int) {
        let iBlue = rgb & 0xFF
        let iGreen =  (rgb >> 8) & 0xFF
        let iRed =  (rgb >> 16) & 0xFF
        let iAlpha =  (rgb >> 24) & 0xFF
        self.init(red: CGFloat(iRed)/255, green: CGFloat(iGreen)/255,
                  blue: CGFloat(iBlue)/255, alpha: CGFloat(iAlpha)/255)
    }
}
