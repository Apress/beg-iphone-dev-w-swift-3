//
//  QuartzFunView.swift
//  QuartzFun
//
//  Created by Molly Maskrey on 7/21/16.
//  Copyright © 2016 Apress Inc. All rights reserved.
//

import UIKit

// Random color extension of UIColor
extension UIColor {
    class func randomColor() -> UIColor {
        let red = CGFloat(Double(arc4random_uniform(255))/255)
        let green = CGFloat(Double(arc4random_uniform(255))/255)
        let blue = CGFloat(Double(arc4random_uniform(255))/255)
        return UIColor(red: red, green: green, blue: blue, alpha:1.0)
    }
}

enum Shape : UInt {
    case line = 0, rect, ellipse, image
}

// The color tab indices
enum DrawingColor : UInt {
    case red = 0, blue, yellow, green, random
}

class QuartzFunView: UIView {
    // Application-settable properties
    var shape = Shape.line
    var currentColor = UIColor.red
    var useRandomColor = false
    
    // Internal properties
    private let image = UIImage(named:"iphone")
    private var firstTouchLocation = CGPoint.zero
    private var lastTouchLocation = CGPoint.zero
    private var redrawRect = CGRect.zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if useRandomColor {
                currentColor = UIColor.randomColor()
            }
            firstTouchLocation = touch.location(in: self)
            lastTouchLocation = firstTouchLocation
            redrawRect = CGRect.zero
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastTouchLocation = touch.location(in: self)
        
            if shape == .image {
                let horizontalOffset = image!.size.width / 2
                let verticalOffset = image!.size.height / 2
                redrawRect = redrawRect.union(CGRect(x: lastTouchLocation.x - horizontalOffset,
                        y: lastTouchLocation.y - verticalOffset,
                        width: image!.size.width, height: image!.size.height))
            } else {
                redrawRect = redrawRect.union(currentRect())
            }
            setNeedsDisplay(redrawRect)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastTouchLocation = touch.location(in: self)
        
            if shape == .image {
                let horizontalOffset = image!.size.width / 2
                let verticalOffset = image!.size.height / 2
                redrawRect = redrawRect.union(CGRect(x: lastTouchLocation.x - horizontalOffset,
                            y: lastTouchLocation.y - verticalOffset,
                            width: image!.size.width, height: image!.size.height))
            } else {
                redrawRect = redrawRect.union(currentRect())
            }
            setNeedsDisplay(redrawRect)
        }
    }
    

    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor(currentColor.cgColor)
        context?.setFillColor(currentColor.cgColor)
       
        switch shape {
        case .line:
            context?.moveTo(x: firstTouchLocation.x,
                                y: firstTouchLocation.y)
            context?.addLineTo(x: lastTouchLocation.x,
                                y: lastTouchLocation.y)
            context?.strokePath()
        
        case .rect:
            context?.addRect(currentRect())
            context?.drawPath(using: .fillStroke)
        
        case .ellipse:
            context?.addEllipse(in: currentRect())
            context?.drawPath(using: .fillStroke)
        
        case .image:
            let horizontalOffset = image!.size.width / 2
            let verticalOffset = image!.size.height / 2
            let drawPoint =
                CGPoint(x: lastTouchLocation.x - horizontalOffset,
                            y: lastTouchLocation.y - verticalOffset)
            image!.draw(at: drawPoint)
        }
    }
    
    
    func currentRect() -> CGRect {
        return CGRect(x: firstTouchLocation.x,
            y: firstTouchLocation.y,
            width: lastTouchLocation.x - firstTouchLocation.x,
            height: lastTouchLocation.y - firstTouchLocation.y)
    }

}
