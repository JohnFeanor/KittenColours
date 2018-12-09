//
//  MyWindowController.swift
//  ReadCatColour
//
//  Created by John Sandercock on 12/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Cocoa


struct Offspring {
  var chance: String
  var colour: String
}

class MyWindowController: NSWindowController {
  
  // Screen view outlets
  @IBOutlet weak var progress: NSProgressIndicator!
  @IBOutlet var sireCat: MaleCat!
  @IBOutlet var damCat: FemaleCat!
  @IBOutlet weak var femaleOffspringTextField: NSTextField!
  @IBOutlet weak var maleOffspringTextField: NSTextField!
//
//  @objc dynamic var maleOffspring = "" {
//    didSet {
//      maleOffspringTextField.stringValue = maleOffspring
//      maleOffspringTextField.sizeToFit()
//
//    }
//  }
//
//  @objc dynamic var femaleOffspring = "" {
//    didSet {
//      femaleOffspringTextField.stringValue = femaleOffspring
//      femaleOffspringTextField.sizeToFit()
//    }
//  }
  
  var maleOffspring: [Offspring] = []
  var femaleOffspring: [Offspring] = []

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
    maleOffspring = []
    femaleOffspring = []
    for color in boyKittens {
      guard let color = color as? String
        else { print("color is not a color"); break }
      let totalChances = boyKittens.count(for: color)
      let gcd = gcdr(totalChances, count)
      let reducedPossibilities = count / gcd
      let reducedChances = totalChances / gcd
      maleOffspring.append(Offspring(chance: "\(reducedChances) in \(reducedPossibilities):", colour: color))
      progress.startAnimation(nil)
    }
    maleOffspring.sort(by: { $0.colour.count < $1.colour.count})
    
    for color in girlKittens {
      guard let color = color as? String
        else { print("color is not a color"); break }
      let totalChances = girlKittens.count(for: color)
      let gcd = gcdr(totalChances, count)
      let reducedPossibilities = count / gcd
      let reducedChances = totalChances / gcd
      
      femaleOffspring.append(Offspring(chance: "\(reducedChances) in \(reducedPossibilities):", colour: color))
      progress.increment(by: 0.1)
      progress.display()
    }
    femaleOffspring.sort(by: { $0.colour.count < $1.colour.count})

    maleOffspringTextField.stringValue = maleOffspring.reduce("", { $0 + $1.chance + " " + $1.colour + "\n" })
    maleOffspringTextField.sizeToFit()

    femaleOffspringTextField.stringValue = femaleOffspring.reduce("", { $0 + $1.chance + " " + $1.colour + "\n" })
    femaleOffspringTextField.sizeToFit()

    progress.stopAnimation(self)
    progress.isHidden = true
  }
  
  /// Prints the outcome of the current mating
  func printMatingOutcome(_ sender: NSMenuItem) {
    let printView = PrintView(sire: sireCat, dam: damCat, maleOffspring: maleOffspring, femaleOffspring: femaleOffspring)
    printView.printView(sender)
  }
  
}
