//
//  ViewController.swift
//  MotionMonitor
//
//  Created by Molly Maskrey on 7/21/16.
//  Copyright © 2016 Apress Inc. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet var gyroscopeLabel: UILabel!
    @IBOutlet var accelerometerLabel: UILabel!
    @IBOutlet var attitudeLabel: UILabel!
    private let motionManager = CMMotionManager()
    private var updateTimer: Timer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates()
            updateTimer =
                Timer.scheduledTimer(timeInterval: 0.1, target: self,
                        selector: #selector(ViewController.updateDisplay), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
            updateTimer.invalidate()
            updateTimer = nil
        }
    }
    
    func updateDisplay() {
       if let motion = motionManager.deviceMotion {
            let rotationRate = motion.rotationRate
            let gravity = motion.gravity
            let userAcc = motion.userAcceleration
            let attitude = motion.attitude
            
            let gyroscopeText =
                String(format: "Rotation Rate:\n-----------------\n" +
                               "x: %+.2f\ny: %+.2f\nz: %+.2f\n",
                        rotationRate.x, rotationRate.y, rotationRate.z)
            let acceleratorText =
                String(format: "Acceleration:\n---------------\n" +
                               "Gravity x: %+.2f\t\tUser x: %+.2f\n" +
                               "Gravity y: %+.2f\t\tUser y: %+.2f\n" +
                               "Gravity z: %+.2f\t\tUser z: %+.2f\n",
                       gravity.x, userAcc.x, gravity.y,
                       userAcc.y, gravity.z,userAcc.z)
            let attitudeText =
                String(format: "Attitude:\n----------\n" +
                               "Roll: %+.2f\nPitch: %+.2f\nYaw: %+.2f\n",
                       attitude.roll, attitude.pitch, attitude.yaw)
        
    
            
            DispatchQueue.main.async {
                self.gyroscopeLabel.text = gyroscopeText
                self.accelerometerLabel.text = acceleratorText
                self.attitudeLabel.text = attitudeText
            }
        }
    }
}

