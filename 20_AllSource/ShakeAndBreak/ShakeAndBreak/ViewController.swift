//
//  ViewController.swift
//  ShakeAndBreak
//
//  Created by Molly Maskrey on 7/21/16.
//  Copyright © 2016 Apress Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    private var fixed: UIImage!
    private var broken: UIImage!
    private var brokenScreenShowing = false
    private var crashPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let url = Bundle(for: type(of: self)).url(forResource:"glass", withExtension:"wav") {
            do {
                crashPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeWAVE)
            } catch let error as NSError {
                print("Audio error! \(error.localizedDescription)")
            }
        }
        
        fixed = UIImage(named: "Home")
        broken = UIImage(named: "HomeBroken")
        imageView.image = fixed
    }
    

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if !brokenScreenShowing && motion == .motionShake {
            imageView.image = broken;
            crashPlayer?.play()
            brokenScreenShowing = true;
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        imageView.image = fixed
        brokenScreenShowing = false
    }

}

