//
//  IntroPoint.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class IntroPoint: UIView {
    
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect)
        
        UIColor(netHex:0xFFFFFF).set()
        path.fill()

        UIColor(netHex:0xBDCEE9).set()
        path.lineWidth = 1.0
        path.stroke()
        
        var circleRect = CGRect(x: rect.size.width / 4, y: rect.size.height / 4, width: rect.size.width / 2, height: rect.size.height / 2)
        
        var cPath: UIBezierPath = UIBezierPath(ovalInRect: circleRect)
        UIColor(netHex:0x46B8FF).set()
        cPath.fill()
    }
}
