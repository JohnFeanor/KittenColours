//
//  MyWindowController.swift
//  ReadCatColour
//
//  Created by John Sandercock on 12/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Cocoa

class MyWindowController: NSWindowController {
  
  var appDelegate: AppDelegate? = nil
  
  // Screen view outlets
  @IBOutlet weak var progress: NSProgressIndicator!
  @IBOutlet var sireCat: MaleCat!
  @IBOutlet var damCat: FemaleCat!
  @IBOutlet weak var femaleOffspringTextField: NSTextField!
  @IBOutlet weak var maleOffspringTextField: NSTextField!
  
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
    appDelegate?.saveable = true
    
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
  
  /// Saves the outcome of the current mating as a RTF file
  func saveMatingOutcome(_ sender: NSMenuItem) {
    let myData = generateData(sire: sireCat, dam: damCat, maleOffspring: maleOffspring, femaleOffspring: femaleOffspring)
    let savePanel = NSSavePanel()
    savePanel.allowedFileTypes = ["rtf"]
    savePanel.isExtensionHidden = false
    savePanel.canSelectHiddenExtension = false
    savePanel.nameFieldStringValue = "untitled.rtf"
    
    savePanel.beginSheetModal(for: window!, completionHandler: {
      [unowned savePanel] (result) in
      if result == NSApplication.ModalResponse.OK {
        self.save(theData: myData, to: savePanel.url)
      }
    })
  }
  
  func save(theData: Data, to thisURL: URL?) {
    guard let thisURL = thisURL else { return }
    do {
      try theData.write(to: thisURL)
    } catch  {
      errormsg("Error writing file: \(error.localizedDescription)")
    }
  }
    
  func generateData(sire: Cat, dam: Cat, maleOffspring: [Offspring], femaleOffspring: [Offspring]) -> Data {
    var theData = readFile("00")
    theData.append(parentDetails(cat: sire))
    theData.append(readFile("03"))
    theData.append(parentDetails(cat: dam))
    theData.append(readFile("06"))
    //Now add the mating outcomes
    let numOffspring = max(maleOffspring.count, femaleOffspring.count)
    for count in 0..<numOffspring {
      theData.append(readFile("start_row"))
      let str1 = """
       \\f3\\b0\\fs22 \\cf0 \(maleOffspring[safe: count].chance)\\cell
       \\pard\\intbl\\itap1\\pardeftab720\\ri0\\sa240\\partightenfactor0
       \\cf0 \(maleOffspring[safe: count].colour)\\cell
       \\pard\\intbl\\itap1\\pardeftab720\\ri0\\sa240\\partightenfactor0
       \\cf0 \(femaleOffspring[safe: count].chance)\\cell
       \\pard\\intbl\\itap1\\pardeftab720\\ri0\\sa240\\partightenfactor0
       \\cf0 \(femaleOffspring[safe: count].colour)\\cell \\row

       """
      theData.add(data: str1)
    }
    theData.append(readFile("end_file"))
    return theData
  }

  func parentDetails(cat: Cat) -> Data {
    let text = """
      \(cat.genome.colour)\\f0\\b \\
      Carrying: \\f1\\b0 \(cat.recessivesCarried.joined(separator: ", "))
      
      \\f0\\b \\
      Masking: \\f1\\b0 \(cat.colorsMasked.joined(separator: ", "))

      """
    return text.data
  }
  
}
