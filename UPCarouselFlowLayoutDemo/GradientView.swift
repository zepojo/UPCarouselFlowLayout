//
//  GradientView.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Paul Ulric on 28/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override func drawRect(rect: CGRect) {
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSaveGState(context)
        
        let startColor: UIColor = UIColor(red: 79.0/255.0, green: 30.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        let endColor: UIColor = UIColor(red: 46.0/255.0, green: 12.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        let colors = [startColor.CGColor, endColor.CGColor]
        let locations: [CGFloat] = [0, 1]
        let gradient: CGGradientRef = CGGradientCreateWithColors(colorSpace, colors, locations)!
        
        let startPoint: CGPoint = CGPoint(x:CGRectGetMidX(rect), y: CGRectGetMinY(rect))
        let endPoint: CGPoint = CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMaxY(rect))
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, [])
        CGContextRestoreGState(context)
    }

}
