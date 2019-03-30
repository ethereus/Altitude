//
//  ViewController.swift
//  Altitude UI
//
//  Created by EvenDev on 21/09/2018.
//  Copyright © 2018 EvenDev. All rights reserved.
//

import Cocoa
import AppKit

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor.init(red: 1, green: 1, blue: 1, alpha: 1)
            self.view.layer?.backgroundColor = color
        }
    }

}

