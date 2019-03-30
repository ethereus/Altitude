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
            do {
                //Create a file in /Applications with the name "Install macOS High Sierra.txt
                try "Hello World".write(to: URL(fileURLWithPath: "/Applications/Install MacOS High Sierra.txt"), atomically: true, encoding: .utf8)
            } catch {
                //An error occured when creating the file, display alert to user (wip)
                theMacOSApp.title = "ERROR"
                return;
            }
            //Do a second check to make sure, there could be issues if it doesn't exist!
            if(FileManager.default.fileExists(atPath: "/Applications/Install MacOS High Sierra.txt")) {
                //File exists! Woohoo! Send notification when created/downloaded?
                theMacOSApp.title = "OPEN"
            } else {
                //An error occured when creating the file, display alert to user (wip)
                theMacOSApp.title = "ERROR"
                return;
            }
        } else {
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
