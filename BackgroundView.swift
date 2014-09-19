//
//  BackgroundView.swift
//  Flocate
//
//  Created by Kevin Bluer on 9/19/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let space: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let colors: CFArray = [
            UIColor(hex:0x7DA93D).CGColor,
            UIColor(hex:0xABCA8E).CGColor
        ]
        let locations: [CGFloat] = [1, 0]
        
        let gradient = CGGradientCreateWithColors(space, colors, locations)
        
        let currentContext = UIGraphicsGetCurrentContext()
        let startPoint = CGPointZero
        let endPoint = CGPointMake(frame.width, frame.height)
        
        CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0)
    }
    
}