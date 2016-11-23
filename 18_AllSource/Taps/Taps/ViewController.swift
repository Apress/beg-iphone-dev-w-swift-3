//
//  ViewController.swift
//  Taps
//
//  Created by Molly Maskrey on 7/21/16.
//  Copyright © 2016 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var singleLabel:UILabel!
    @IBOutlet var doubleLabel:UILabel!
    @IBOutlet var tripleLabel:UILabel!
    @IBOutlet var quadrupleLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.singleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.doubleTap))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
        
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tripleTap))
        tripleTap.numberOfTapsRequired = 3
        tripleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tripleTap)
        doubleTap.require(toFail: tripleTap)
        
        let quadrupleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.quadrupleTap))
        quadrupleTap.numberOfTapsRequired = 4
        quadrupleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(quadrupleTap)
        tripleTap.require(toFail: quadrupleTap)
       
    }

    func singleTap() {
        showText("Single Tap Detected", inLabel: singleLabel)
    }
    
    func doubleTap() {
        showText("Double Tap Detected", inLabel: doubleLabel)
    }
    
    func tripleTap() {
        showText("Triple Tap Detected", inLabel: tripleLabel)
    }
    
    func quadrupleTap() {
        showText("Quadruple Tap Detected", inLabel: quadrupleLabel)
    }
    
    private func showText(_ text: String, inLabel label: UILabel) {
        label.text = text
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            label.text = ""
        })
    }
}

