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
    @IBOutlet var theScrollThing: NSScroller!
    @IBOutlet weak var theMacOSApp: NSButton!
    
    @IBAction func myTestPressed(_ sender: Any) {
        //Check if it exists already, if it does, open! If not, create file
        if(!FileManager.default.fileExists(atPath: "/Applications/Install MacOS High Sierra.txt")) {
            theMacOSApp.title = "GET"
            
            let url = URL(string: "https://conorthedev.com/test.txt")
            
            //Download the file
            Downloader.init().Download(downloadURL: url!, downloadedName: "Install MacOS High Sierra.txt", button: theMacOSApp)
        } else {
            theMacOSApp.title = "OPEN"
            //Open file
            NSWorkspace.init().openFile("/Applications/Install MacOS High Sierra.txt")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
    
        theBigGay.appearance = NSAppearance(named: .vibrantDark)
        theScrollThing.appearance = NSAppearance(named: .vibrantDark)
        if (FileManager.default.fileExists(atPath: "/Applications/Install MacOS High Sierra.txt")) {
            theMacOSApp.title = "OPEN"
        } else {
            theMacOSApp.title = "GET"
       
        }
    }
}
