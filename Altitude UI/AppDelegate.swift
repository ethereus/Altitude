//
//  AppDelegate.swift
//  Altitude UI
//
//  Created by EvenDev on 21/09/2018.
//  Copyright © 2018 EvenDev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var myController: NSWindowController?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let storyBoard = NSStoryboard(name: NSStoryboard.Name(rawValue: "DarkMode"), bundle: nil)
        myController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "applicationsController")) as? NSWindowController
        myController?.showWindow(self)
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

