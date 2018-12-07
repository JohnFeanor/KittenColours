//
//  AppDelegate.swift
//  ReadCatColour
//
//  Created by John Sandercock on 12/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  var mainWindowController: MyWindowController?

  @IBOutlet weak var window: NSWindow!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Create a window controller
    let mainWindowController = MyWindowController()
    //Put the window of the window controller on screen
    mainWindowController.showWindow(self)
    
    //Set the property to point to the window controller
    self.mainWindowController = mainWindowController
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  @IBAction func printMatingOutcome(_ sender: NSMenuItem) {
  mainWindowController?.printMatingOutcome(sender)
  }

}

