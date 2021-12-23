//
//  AppDelegate.swift
//  ReadCatColour
//
//  Created by John Sandercock on 12/11/18.
//  Copyright © 2021 Feanor. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  var mainWindowController: MyWindowController?
  @objc var saveable = false

  @IBOutlet weak var window: NSWindow!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let notificationCentre = NotificationCenter.default

    // Create a window controller
    let mainWindowController = MyWindowController()
    notificationCentre.addObserver(self, selector: #selector(haveAMating), name: NSNotification.Name(OffspringHasBeenDetermined), object: nil)
    //Put the window of the window controller on screen
    mainWindowController.showWindow(self)
    
    //Set the property to point to the window controller
    self.mainWindowController = mainWindowController
  }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
    print("KittenColours will quit")
    let notificationCentre = NotificationCenter.default
    notificationCentre.removeObserver(self)
  }
  
  @IBAction func printMatingOutcome(_ sender: NSMenuItem) {
  mainWindowController?.printMatingOutcome(sender)
  }
  
  @IBAction func saveMatingOutcome(_ sender: NSMenuItem) {
    mainWindowController?.saveMatingOutcome(sender)
  }
  
  @objc func haveAMating() {
    saveable = true
  }
  
}

