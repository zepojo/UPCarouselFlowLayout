//
//  GradientView.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Paul Ulric on 28/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override func draw(_ rect: CGRect) {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        let startColor: UIColor = UIColor(red: 79.0/255.0, green: 30.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        let endColor: UIColor = UIColor(red: 46.0/255.0, green: 12.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        let colors = [startColor.cgColor, endColor.cgColor]
        let locations: [CGFloat] = [0, 1]
        let gradient: CGGradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)!
        
        let startPoint: CGPoint = CGPoint(x:rect.midX, y: rect.minY)
        let endPoint: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.restoreGState()
    }

}
