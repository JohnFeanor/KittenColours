//
//  Cat.swift
//  ReadCatColour
//
//  Created by John Sandercock on 13/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Cocoa

enum Sex {
  case male
  case female
}

fileprivate enum PopUpMenu: Int {
  case color = 0
  case patching = 1
  case tabby = 2
}

class Cat: NSObject {
  
  @IBOutlet weak var colorTextField: NSTextField!
  @IBOutlet weak var genomeTextField: NSTextField!
  
  @objc dynamic let tabbyPatterns = [CatCoat.none.description, CatCoat.ticked.description, CatCoat.mackeral.description, CatCoat.classic.description]
  let tabbyMenuItems: [CatCoat] = [.none, .ticked, .mackeral, .classic]
  @objc dynamic let whiteSpotting = [CatCoat.none.description, CatCoat.van.description, CatCoat.biColor.description]
  let patchingMenuItems: [CatCoat] = [.none, .van, .biColor]
  
  @objc dynamic var availableColors: [String] = []
  var colorMenuItems: [CatCoat] = []
  
  @IBOutlet weak var diluteButton: NSButton!
  @IBOutlet weak var brownButton: NSButton!
  @IBOutlet weak var colorPointButton: NSButton!
  @IBOutlet weak var sepiaButton: NSButton!
  @IBOutlet weak var selfButton: NSButton!
  
  @objc dynamic var diluteButtonValue: Bool = false {
    didSet {
      genome.density[2] = (diluteButtonValue ? .dilute : .dense)
      genomeTextField.stringValue = genome.description
    }
  }
  @objc dynamic var brownButtonValue: Bool = false {
    didSet {
      if brownButtonValue {
        cinnamonButtonValue = false
        genome.pigment[2] = .b
      } else {
        genome.pigment[2] = genome.pigment[1]
      }
      genomeTextField.stringValue = genome.description
    }
  }
  @objc dynamic var cinnamonButtonValue: Bool = false {
    didSet {
      if cinnamonButtonValue {
        brownButtonValue = false
        genome.pigment[2] = .b1
      } else {
        genome.pigment[2] = genome.pigment[1]
      }
      genomeTextField.stringValue = genome.description
    }
  }
  @objc dynamic var colorPointButtonValue: Bool = false {
    didSet {
      if colorPointButtonValue {
        sepiaButtonValue = false
        genome.albinism[2] = .cs
      } else {
        genome.albinism[2] = genome.albinism[1]
      }
      genomeTextField.stringValue = genome.description
    }
  }
  @objc dynamic var sepiaButtonValue: Bool = false {
    didSet {
      if sepiaButtonValue {
        colorPointButtonValue = false
        genome.albinism[2] = .cb
      } else {
        genome.albinism[2] = genome.albinism[1]
      }
      genomeTextField.stringValue = genome.description
    }
  }
  
  @objc dynamic var selfButtonValue: Bool = false {
    didSet {
      genome.agouti[2] = (selfButtonValue ? .a : genome.agouti[1] )
      genomeTextField.stringValue = genome.description
    }
  }
  
  @objc dynamic var nonWhiteButtonValue: Bool = false {
    didSet {
      genome.white[2] = nonWhiteButtonValue ? .notWhite : .white
      genomeTextField.stringValue = genome.description
    }
  }
  
  @objc dynamic var redMaskingButtonValue: Bool = false {
    didSet {
      if redMaskingButtonValue {
        tortieMaskingButtonValue = false
        genome.orange[1] = .O
        if self.sex == .female {
          genome.orange[2] = .O
        } else {
          genome.orange[2] = .none
        }
      } else {
        genome.orange[1] = .o
        if self.sex == .female { genome.orange[2] = .o }
      }
      genomeTextField.stringValue = genome.description
    }
  }
  
  @objc dynamic var tortieMaskingButtonValue: Bool = false {
    didSet {
      guard self.sex == .female else { return }
      if tortieMaskingButtonValue {
        redMaskingButtonValue = false
        genome.orange[1] = .O
        genome.orange[2] = .o
      } else {
        genome.orange.fill(with: .o)
      }
      genomeTextField.stringValue = genome.description
    }
  }
  
  @objc dynamic var brownMaskingButtonValue: Bool = false {
    didSet {
      if brownMaskingButtonValue {
        cinnamonMaskingButtonValue = false
        genome.pigment.limit(with: .b, allowingRecessives: cinnamonButtonValue)
      }
        // MARK: ToDo
      else {
        genome.pigment[1] = .B
        genome.pigment[2] = pigmentForGene2
      }
      genomeTextField.stringValue = genome.description
    }
  }
  
  @objc dynamic var cinnamonMaskingButtonValue: Bool = false {
    didSet {
      if cinnamonMaskingButtonValue {
        brownMaskingButtonValue = false
        genome.pigment.fill(with: .b1)
      }
        // MARK: ToDo
      else {
        genome.pigment[1] = .B
        genome.pigment[2] = pigmentForGene2
      }
      genomeTextField.stringValue = genome.description
    }
  }
  
  var pigmentForGene2: Pigment {
    if cinnamonButtonValue { return .b1 }
    if brownButtonValue { return .b }
    return .B
  }
  
  @objc dynamic var diluteButtonActive: Bool = true
  @objc dynamic var brownButtonActive: Bool = true
  @objc dynamic var cinnamonButtonActive: Bool = true
  @objc dynamic var colorPointButtonActive: Bool = true
  @objc dynamic var sepiaButtonActive: Bool = true
  @objc dynamic var selfButtonActive: Bool = false
  @objc dynamic var nonWhiteButtonActive = false
  @objc dynamic var redMaskingButtonActive: Bool = false
  @objc dynamic var tortieMaskingButtonActive: Bool = false
  @objc dynamic var brownMaskingButtonActive: Bool = false
  @objc dynamic var cinnamonMaskingButtonActive: Bool = false
  
  @objc dynamic var myGenome = ""
  
  internal var genome = Chromosome()
  var sex: Sex {
    return .female
  }
  
  override func awakeFromNib() {
    availableColors = colorMenuItems.map { $0.description }
    colorTextField.stringValue = genome.colour
    genomeTextField.stringValue = genome.description
  }
  
  @IBAction func menuSelected(_ sender: NSPopUpButton) {
    let selection = sender.titleOfSelectedItem ?? "no selection"
    let selectedIndex = sender.indexOfSelectedItem
    guard let id = PopUpMenu(rawValue: sender.tag)
      else { print("Unknown popUpMenu tag \(sender.tag)"); return }
    switch id {
    case .color:
      do {
        let colorChosen = colorMenuItems[safe: selectedIndex]
        try change(color: colorChosen )
      } catch ParameterError.nilValue {
        print("Could not figure out what colour '\(selection) is")
      } catch {
        print("unknown error")
      }
    case .patching:
      do {
        let patchingChosen = patchingMenuItems[safe: selectedIndex]
        try change(patching: patchingChosen)
      } catch ParameterError.nilValue {
        print("Could not figure out what patching '\(selection) is")
      } catch ParameterError.incorrectValue(let wrong) {
        print("Patching value of '\(wrong)' not recognised")
      } catch {
        print("unknown error")
      }
    case .tabby:
      do {
        let tabbyChosen = tabbyMenuItems[safe: selectedIndex]
        try change(tabby: tabbyChosen)
      } catch ParameterError.nilValue {
        print("Could not figure out what patching '\(selection) is")
      } catch ParameterError.incorrectValue(let wrong) {
        print("Patching value of '\(wrong)' not recognised")
      } catch {
        print("unknown error")
      }
    }
    colorTextField.stringValue = genome.colour
    genomeTextField.stringValue = genome.description
  }
  
  func change(tabby: CatCoat?) throws {
    guard let tabby = tabby
      else { throw ParameterError.nilValue }
    selfButtonActive = true
    switch tabby {
    case .none:
      genome.agouti.fill(with: .a)
      selfButtonActive = false
    case .ticked:
      genome.agouti.limit(with: .A, allowingRecessives: selfButtonValue)
      genome.ticking.fill(with: .Ti)
    case .mackeral:
      genome.agouti.limit(with: .A, allowingRecessives: selfButtonValue)
      genome.ticking.fill(with: .ti)
      genome.tabby.fill(with: .Mc)
    case .classic:
      genome.agouti.limit(with: .A, allowingRecessives: selfButtonValue)
      genome.ticking.fill(with: .ti)
      genome.tabby.fill(with: .mc)
    default:
      throw ParameterError.incorrectValue(value: tabby.description)
    }
  }
  
  func change(patching: CatCoat?) throws {
    guard let patching = patching
      else { throw ParameterError.nilValue }
    switch patching {
    case .none:
      genome.spotting.fill(with: .s)
    case .van:
      genome.spotting.fill(with: .S)
    case .biColor:
      genome.spotting[1] = .S
      genome.spotting[2] = .s
    default:
      throw ParameterError.incorrectValue(value: patching.description)
    }
  }
  
  func change(color: CatCoat?) throws {
    guard let color = color
      else { throw ParameterError.nilValue }
    
    if diluteButtonValue { genome.density[2] = .dilute }
    if brownButtonValue { genome.pigment[2] = .b }
    if cinnamonButtonValue { genome.pigment[2] = .b1 }
    if colorPointButtonValue { genome.albinism[2] = .cs }
    if sepiaButtonValue { genome.albinism[2] = .cb }
    if selfButtonValue { genome.agouti[2] = .a }
    if nonWhiteButtonValue { genome.white[2] = .notWhite }
    
    genome.orange.limit(with: .o, allowingRecessives: true)
    if color == CatCoat.white {
      genome.white.limit(with: .white, allowingRecessives: true)
      setCarryingButtons(nonWhite: true)
      setMaskingButtons()
      return
    }
    genome.white.fill(with: .notWhite)
    genome.albinism.limit(with: .C, allowingRecessives: true)
    setMaskingButtons(on: false)
    
    if blackCats.contains(color) {
      genome.black(dilute: diluteButtonValue, pigment: brownButtonValue || cinnamonButtonValue)
      setCarryingButtons()
    } else if blueCats.contains(color) {
      genome.blue(pigment: brownButtonValue || cinnamonButtonValue)
      setCarryingButtons(dilute: false)
    } else if brownCats.contains(color) {
      genome.brown(dilute: diluteButtonValue, pigment: cinnamonButtonValue)
      setCarryingButtons(brown: false)
    } else if lilacCats.contains(color) {
      genome.lilac(pigment: cinnamonButtonValue)
      setCarryingButtons(dilute: false, brown: false)
    } else if cinnamonCats.contains(color) {
      genome.cinnamon(dilute: diluteButtonValue)
      setCarryingButtons(brown: false, cinnamon: false)
    } else if fawnCats.contains(color) {
      genome.fawn()
      setCarryingButtons(dilute: false, brown: false, cinnamon: false)
    } else if redCats.contains(color) {
      genome.red(sex: self.sex, dilute: diluteButtonValue, pigment: brownButtonValue || cinnamonButtonValue)
      setMaskingButtons(red: false, tortie: false)
      setCarryingButtons()
    } else if creamCats.contains(color) {
      genome.cream(sex: self.sex, pigment: brownButtonValue || cinnamonButtonValue)
      setMaskingButtons(red: false, tortie: false)
      setCarryingButtons(dilute: false)
    } else {
      print("Unknown colour '\(color)'")
    }
    
    if tortieCats.contains(color) {
      genome.tortie()
    }
    if pointedCats.contains(color) {
      genome.point()
      disableCarryingPoints()
    } else if sepiaCats.contains(color) {
      genome.sepia()
      disableCarryingPoints()
    } else if minkCats.contains(color) {
      genome.mink()
      disableCarryingPoints()
    }
  }
  
  private func setCarryingButtons(dilute: Bool = true, brown: Bool = true, cinnamon: Bool = true, colorPoint: Bool = true, sepia: Bool = true, nonWhite: Bool = false) {
    set(flag: &diluteButtonActive, to: dilute)
    set(flag: &brownButtonActive, to: brown)
    set(flag: &cinnamonButtonActive, to: cinnamon)
    set(flag: &colorPointButtonActive, to: colorPoint)
    set(flag: &sepiaButtonActive, to: sepia)
    set(flag: &nonWhiteButtonActive, to: nonWhite)
  }
  
  private func setMaskingButtons(red: Bool = true, tortie: Bool = true, brown: Bool = true, cinnamon: Bool = true) {
    set(flag: &redMaskingButtonActive, to: red)
    set(flag: &brownMaskingButtonActive, to: brown)
    set(flag: &tortieMaskingButtonActive, to: tortie)
    set(flag: &cinnamonMaskingButtonActive, to: cinnamon)
  }
  
  private func setMaskingButtons(on: Bool) {
    set(flag: &redMaskingButtonActive, to: on)
    if redMaskingButtonValue { redMaskingButtonValue = false }
    set(flag: &brownMaskingButtonActive, to: on)
    if brownMaskingButtonValue { brownMaskingButtonValue = false }
    set(flag: &tortieMaskingButtonActive, to: on)
    if tortieMaskingButtonValue { tortieMaskingButtonValue = false }
    set(flag: &cinnamonMaskingButtonActive, to: on)
    if cinnamonMaskingButtonValue { cinnamonMaskingButtonValue = false }
  }
  
  private func disableCarryingPoints() {
    set(flag: &colorPointButtonActive, to: false)
    set(flag: &sepiaButtonActive, to: false)
  }
  
  func mated(with partner: Cat) -> (boys: NSCountedSet, girls: NSCountedSet) {
    let boyKittens = NSCountedSet()
    let girlKittens = NSCountedSet()
    
    let newPigments   = self.genome.pigment.allelesPossible(with: partner.genome.pigment)
    let newDensities  = self.genome.density.allelesPossible(with: partner.genome.density)
    let newOranges    = self.genome.orange.allelesPossible(with: partner.genome.orange)
    let newAgoutis    = self.genome.agouti.allelesPossible(with: partner.genome.agouti)
    let newWhites     = self.genome.white.allelesPossible(with: partner.genome.white)
    let newGlovings    = self.genome.gloving.allelesPossible(with: partner.genome.gloving)
    let newColourRestrictions = self.genome.albinism.allelesPossible(with: partner.genome.albinism)
    let newSpottings  = self.genome.spotting.allelesPossible(with: partner.genome.spotting)
    let newTabbies    = self.genome.tabby.allelesPossible(with: partner.genome.tabby)
    let newTicking = self.genome.ticking.allelesPossible(with: partner.genome.ticking)
    
    for p in newPigments {
      for d in newDensities {
        for o in newOranges {
          for a in newAgoutis {
            for w in newWhites {
              for g in newGlovings {
                for cr in newColourRestrictions {
                  for s in newSpottings {
                    for t in newTabbies {
                      for ti in newTicking {
                        var c = Chromosome()
                        c.pigment = p
                        c.density = d
                        c.orange = o
                        c.agouti = a
                        c.white = w
                        c.gloving = g
                        c.albinism = cr
                        c.spotting = s
                        c.tabby = t
                        c.ticking = ti
                        if c.male {
                          boyKittens.add(c.colour)
                        } else {
                          girlKittens.add(c.colour)
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return (boyKittens, girlKittens)
  }
}
