//
//  FeaturedTab.swift
//  Altitude UI
//
//  Created by EvenDev on 26/09/2018.
//  Copyright © 2018 EvenDev. All rights reserved.
//

import Cocoa
import AppKit
class featuredTab: NSViewController {
    
    @IBOutlet var theBigGay: NSBox!
    @IBOutlet var theMacOSLabel: NSTextField!
    @IBOutlet var theScrollThing: NSScroller!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
    
        theBigGay.appearance = NSAppearance(named: .vibrantDark)
        theScrollThing.appearance = NSAppearance(named: .vibrantDark)
        if (FileManager.default.fileExists(atPath: "/Applications/Install MacOS High Sierra.app")) {
            theMacOSLabel.stringValue = "OPEN"
        } else {
            theMacOSLabel.stringValue = "GET"
       
        }
    }
}
