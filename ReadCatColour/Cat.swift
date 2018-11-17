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
  
  @objc dynamic let tabbyPatterns = [CatCoat.none.description, CatCoat.ticked.description, CatCoat.mackeral.description, CatCoat.classic.description]
  let tabbyMenuItems: [CatCoat] = [.none, .ticked, .mackeral, .classic]
  @objc dynamic let whiteSpotting = [CatCoat.none.description, CatCoat.van.description, CatCoat.biColor.description]
  let patchingMenuItems: [CatCoat] = [.none, .van, .biColor]
  
  @objc dynamic var availableColors: [String] = []
  var colorMenuItems: [CatCoat] = []

  private var genome = Chromosome()
  var sex: Sex {
    return .female
  }
  
  override func awakeFromNib() {
    availableColors = colorMenuItems.map { $0.description }
    colorTextField.stringValue = genome.colour
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
  }
  
  func change(tabby: CatCoat?) throws {
    guard let tabby = tabby
      else { throw ParameterError.nilValue }
    switch tabby {
    case .none:
      genome.agouti.fill(with: .a)
    case .ticked:
      genome.agouti.fill(with: .A)
      genome.ticking.fill(with: .Ti)
    case .mackeral:
      genome.agouti.fill(with: .A)
      genome.ticking.fill(with: .ti)
      genome.tabby.fill(with: .Mc)
    case .classic:
      genome.agouti.fill(with: .A)
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

    genome.orange.limit(with: .o)
    if color == CatCoat.white {
      genome.white.fill(with: .white)
      return
    }
    genome.white.limit(with: .notWhite)
    
    if blackCats.contains(color) {
      genome.black()
    } else if blueCats.contains(color) {
      genome.blue()
    } else if brownCats.contains(color) {
      genome.brown()
    } else if lilacCats.contains(color) {
      genome.lilac()
    } else if cinnamonCats.contains(color) {
      genome.cinnamon()
    } else if fawnCats.contains(color) {
      genome.fawn()
    } else if redCats.contains(color) {
      genome.red()
    } else if creamCats.contains(color) {
      genome.cream()
    } else {
      print("Unknown colour '\(color)'")
    }
    
    if tortieCats.contains(color) {
      genome.tortie()
    }
    if pointedCats.contains(color) {
      genome.point()
    } else if sepiaCats.contains(color) {
      genome.sepia()
    } else if minkCats.contains(color) {
      genome.mink()
    }
  }
}
