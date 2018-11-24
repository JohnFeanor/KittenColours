//
//  MyWindowController.swift
//  ReadCatColour
//
//  Created by John Sandercock on 12/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Cocoa

class MyWindowController: NSWindowController {
  
  @IBOutlet weak var progress: NSProgressIndicator!
  @IBOutlet var sireCat: MaleCat!
  @IBOutlet var damCat: FemaleCat!
  @IBOutlet weak var femaleOffspringTextField: NSTextField!
  @IBOutlet weak var maleOffspringTextField: NSTextField!
  
  @objc dynamic var maleOffspring = "" {
    didSet {
      maleOffspringTextField.stringValue = maleOffspring
      maleOffspringTextField.sizeToFit()

    }
  }
  
  @objc dynamic var femaleOffspring = "" {
    didSet {
      femaleOffspringTextField.stringValue = femaleOffspring
      femaleOffspringTextField.sizeToFit()
    }
  }

  override var windowNibName: String {
    return "MyWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  @IBAction func mating(_ sender: NSButton) {
    progress.isHidden = false
    progress.startAnimation(self)
    self.perform(#selector(MyWindowController.determineOffspring), with: nil, afterDelay: 0.1)
  }
  
  
  @objc func determineOffspring(){
    progress.startAnimation(self)
    let kittens = sireCat.mated(with: damCat)
    let boyKittens = kittens.boys
    let girlKittens = kittens.girls
    
    var count = 0
    for color in boyKittens {
      count += boyKittens.count(for: color)
    }
    maleOffspring = ""
    femaleOffspring = ""
    var maleKittens: [String] = []
    var femaleKittens: [String] = []
    for color in boyKittens {
      guard let color = color as? String
        else { print("color is not a color"); break }
      let totalChances = boyKittens.count(for: color)
      let gcd = gcdr(totalChances, count)
      let reducedPossibilities = count / gcd
      let reducedChances = totalChances / gcd
      maleKittens.append("\(reducedChances) in \(reducedPossibilities): \(color)\n")
      progress.startAnimation(nil)
    }
    maleKittens.sort()
    maleOffspring = maleKittens.reduce("", { return $0 + $1 })
    for color in girlKittens {
      guard let color = color as? String
        else { print("color is not a color"); break }
      let totalChances = girlKittens.count(for: color)
      let gcd = gcdr(totalChances, count)
      let reducedPossibilities = count / gcd
      let reducedChances = totalChances / gcd
      femaleKittens.append("\(reducedChances) in \(reducedPossibilities): \(color)\n")
      progress.increment(by: 0.1)
      progress.display()
    }
    femaleKittens.sort()
    femaleOffspring = femaleKittens.reduce("", { return $0 + $1 })

    progress.stopAnimation(self)
    progress.isHidden = true
  }
}
