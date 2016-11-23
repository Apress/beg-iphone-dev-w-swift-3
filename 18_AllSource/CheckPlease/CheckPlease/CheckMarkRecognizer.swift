//
//  CheckMarkRecognizer.swift
//  CheckPlease
//
//  Created by Molly Maskrey on 7/21/16.
//  Copyright © 2016 Apress Inc. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class CheckMarkRecognizer: UIGestureRecognizer {
    private static let minimumCheckMarkLengthDown = CGFloat(30)
    private static let minimumCheckMarkLengthUp = CGFloat(50)
    private static let tolerance = CGFloat(16)
    private var startPoint = CGPoint.zero
    private var turnPoint: CGPoint? = nil
    var greatestForce = CGFloat(0)
    var maxPossibleForce = CGFloat(0)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            startPoint = touch.location(in: view)
            turnPoint = nil
            greatestForce = 0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            let previousPoint = touch.previousLocation(in: view)
            if turnPoint == nil {
                // First part - should move down and to the right
                let distanceFromStart = distanceBetweenPoints(first: startPoint, second: currentPoint)
                if (currentPoint.x <= startPoint.x || currentPoint.y <= startPoint.y)
                        && distanceFromStart > CheckMarkRecognizer.tolerance {
                    // Too far above or to the left
                    state = .failed
                }
                
                if distanceFromStart >= CheckMarkRecognizer.minimumCheckMarkLengthDown
                        && currentPoint.x > previousPoint.x && currentPoint.y > previousPoint.y {
                    // Moved far enough down and to the right and now moving up and to the right -
                    // we have reached the turning point.
                    turnPoint = previousPoint
                }
            } else {
                // Second part - should move up and to the right.
                let distanceFromTurn = distanceBetweenPoints(first: turnPoint!, second: currentPoint)
                if currentPoint.x > previousPoint.x && currentPoint.y < previousPoint.y
                        && distanceFromTurn >= CheckMarkRecognizer.minimumCheckMarkLengthUp {
                    // Moved far enough up and to the right - recognize gesture
                    state = .ended
                }
            }
        
            if touch.view?.traitCollection.forceTouchCapability == .available
                    && touch.force > greatestForce {
                greatestForce = touch.force
                maxPossibleForce = touch.maximumPossibleForce
            }
        }
    }
    
    private func distanceBetweenPoints(first: CGPoint, second: CGPoint) -> CGFloat {
        let deltaX = second.x - first.x
        let deltaY = second.y - first.y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
}
