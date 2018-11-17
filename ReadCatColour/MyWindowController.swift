//
//  MyWindowController.swift
//  ReadCatColour
//
//  Created by John Sandercock on 12/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Cocoa

class MyWindowController: NSWindowController {
  
  @IBOutlet var sireCat: Cat!
  
  override var windowNibName: String {
    return "MyWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
}
