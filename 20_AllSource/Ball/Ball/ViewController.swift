//
//  ViewController.swift
//  Ball
//
//  Created by Molly Maskrey on 7/21/16.
//  Copyright © 2016 Apress Inc. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    private static let updateInterval = 1.0/60.0
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        motionManager.startDeviceMotionUpdates(to: queue) {
//                (motionData: CMDeviceMotion?, error: NSError?) -> Void in
//            let ballView = self.view as! BallView
//            ballView.acceleration = motionData!.gravity
//            DispatchQueue.main.async {
//                ballView.update()
//            }
//        }
        
        motionManager.startDeviceMotionUpdates(to: queue, withHandler: {_,_ in 
            let ballView = self.view as! BallView
//            ballView.acceleration = motionData!.gravity
            DispatchQueue.main.async {
                ballView.update()
            }
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

