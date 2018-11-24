//
//  Genome.swift
//  CatColours2
//
//  Created by John Sandercock on 11/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Foundation

protocol Gene {
  associatedtype Trait
  /**
   ### Usage Example: ###
   ````
     Pigment.B.fuse(.b) // "Black"
   ````
   - returns:
   - the resultant colour or pattern created by the calller and other allele fusing together
   */
  func fuse(other: Self) -> Trait
  
  /** - returns:
   - `true` if calling allele dominates other allelle
   - `false` otherwise
 */
  func dominates(other: Self) -> Bool
  
  var code: String { get }
}

enum Pigment: Gene {
  case B
  case b
  case b1
  
  func dominates(other: Pigment) -> Bool {
    switch (self, other) {
    case (_, .B), (.b1, _):
      return false
    case (.B, _):
      return true
    case (.b, .b1):
      return true
    default:
      return false
    }
  }
  
  func fuse(other: Pigment) -> Pigment {
    switch (self, other) {
    case (.b1, .b1):
      return .b1
    case (.B, _), (_, .B):
      return .B
    default:
      return .b
    }
  }
  
  var code: String {
    switch self {
    case .B:
      return "B"
    case .b:
      return "b"
    case .b1:
      return "b1"
    }
  }
}

enum Density: Gene {
  case dense
  case dilute
  
  func dominates(other: Density) -> Bool {
    switch (self, other) {
    case (.dense, .dilute):
      return true
    default:
      return false
    }
  }
  
  func fuse(other: Density) -> Density {
    switch (self, other) {
    case (.dilute, .dilute):
      return .dilute
    default:
      return .dense
    }
  }
  
  var code: String {
    switch self {
    case .dense:
      return "D"
    case .dilute:
      return "d"
    }
  }
}

enum OrangeEffect {
  case red
  case none
  case tortie
  
  }

enum Orange: Gene {
  case O
  case o
  case none
  
  func dominates(other: Orange) -> Bool {
    switch (self, other) {
    case (_, .O):
      return false
    case (.O, _), (_, .none):
      return true
    default:
      return false
    }
  }
  
  func fuse(other: Orange) -> OrangeEffect {
    switch (self, other) {
    case (.O, .o), (.o, .O):
      return .tortie
    case (.O, _), (_, .O):
      return .red
    default:
      return .none
    }
  }
  
  var code:String {
    switch self {
    case .O:
      return "O"
    case .o:
      return "o"
    case .none:
      return "_"
    }
  }
}

enum Agouti: Gene {
  case A
  case a
  
  var active: Bool { return self == .A }
  
  func dominates(other: Agouti) -> Bool {
    switch (self, other) {
    case (.A, .a):
      return true
    default:
      return false
    }
  }
  
  func fuse(other: Agouti) -> Agouti {
    switch (self, other) {
    case (.a, .a):
      return .a
    default:
      return .A
    }
  }
  
  var code: String {
    switch self {
    case .A:
      return "A"
    case .a:
      return "a"
    }
  }
}

enum White: String, Gene, CustomStringConvertible {
  case white = "White"
  case notWhite = "None"
  
  var active: Bool { return self == .white }
  
  var description: String {
    return self.rawValue
  }
  
  func dominates(other: White) -> Bool {
    switch (self, other) {
    case (.white, .notWhite):
      return true
    default:
      return false
    }
  }
   
  func fuse(other: White) -> White {
    switch (self, other) {
    case (.notWhite, .notWhite):
      return .notWhite
    default:
      return .white
    }
  }
    
    var code: String {
      switch self {
      case .white:
        return "W"
      case .notWhite:
        return "w"
      }
    }
}

enum Gloving: Gene, CustomStringConvertible {
  case none
  case gloving
  
  var description: String {
    if self == .gloving { return CatCoat.gloved.description }
    return ""
  }
  
  func dominates(other: Gloving) -> Bool {
    switch (self, other) {
    case (.none, .gloving):
      return true
    default:
      return false
    }
  }
  
  func fuse(other: Gloving) -> Gloving {
    switch (self, other) {
    case (.gloving, .gloving):
      return .gloving
    default:
      return .none
    }
  }
  
  var code: String {
    switch self {
    case .gloving:
      return "g"
    case .none:
      return "Ng"
    }
  }
}

enum AlbinoEffect: CustomStringConvertible {
  case none
  case colorPoint
  case mink
  case sepia
  case blueEyedAlbino
  case pinkEyedAlbino

  var description: String {
    switch self {
    case .blueEyedAlbino:
      return CatCoat.blueEyedAlbino.description
    case.pinkEyedAlbino:
      return CatCoat.pinkEyedAlbino.description
    case .colorPoint:
      return CatCoat.colorPoint.description
    case .mink:
      return CatCoat.mink.description
    case .sepia:
      return CatCoat.sepia.description
    case .none:
      return ""
    }
  }
}

enum Albinism: Gene {
  case C
  case cs
  case cb
  case ca
  case c
  
  func dominates(other: Albinism) -> Bool {
    switch (self, other) {
    case (_, .C):
      return false
    case (.C, _):
      return true
    case (_, .cs):
      return false
    case (.cs, _):
      return true
    case (_, .cb):
      return false
    case (.cb, _):
      return true
    case (.ca, .c):
      return true
    default:
      return false
    }
  }
  
  func fuse(other: Albinism) -> AlbinoEffect {
    switch (self, other) {
    case (.C, _), (_, .C):
      return .none
    case (.cs, .cb), (.cb, .cs):
      return .mink
    case (.cs, _), (_, .cs):
      return .colorPoint
    case (.cb, _), (_, .cb):
      return .sepia
    case (.ca, _), (_, .ca):
      return .blueEyedAlbino
    default:
      return .pinkEyedAlbino
    }
  }
  
  var code: String {
    switch self {
    case .C:
      return "C"
    case .cs:
      return "cs"
    case .cb:
      return "cb"
    case .ca:
      return "ca"
    case .c:
      return "c"
    }
  }
}

enum Patching: CustomStringConvertible {
  case none
  case van
  case biColor
  
  var description: String {
    switch self {
    case .none:
      return ""
    case .van:
      return CatCoat.van.description
    case .biColor:
      return CatCoat.biColor.description
    }
  }
}

enum Spotting: Gene {
  case S
  case s
  
  func dominates(other: Spotting) -> Bool {
    switch (self, other) {
    case (.S, .s):
      return true
    default:
      return false
    }
  }
  
  func fuse(other: Spotting) -> Patching {
    switch (self, other) {
    case (.S, .S):
      return .van
    case (.s, .s):
      return .none
    default:
      return .biColor
    }
  }
  
  var code: String {
    switch self {
    case .S:
      return "S"
    case .s:
      return "s"
    }
  }
}

enum Tabby: Gene, CustomStringConvertible {
  case Mc
  case mc
  
  var description: String {
    switch self {
    case .Mc:
      return CatCoat.mackeral.description
    case .mc:
      return CatCoat.classic.description
    }
  }

  func dominates(other: Tabby) -> Bool {
    switch (self, other) {
    case (.Mc, .mc):
      return true
    default:
      return false
    }
  }
  
  func fuse(other: Tabby) -> Tabby {
    switch (self, other) {
    case (.mc, .mc):
      return .mc
    default:
      return .Mc
    }
  }
  
  var code: String {
    switch self {
    case .Mc:
      return "Mc"
    case .mc:
      return "mc"
    }
  }
}

enum Ticking: Gene, CustomStringConvertible {
  case Ti
  case ti
  
  var description: String {
    if self == .Ti { return CatCoat.ticked.description }
    return ""
  }
  
  var active: Bool { return self != .ti }

  func dominates(other: Ticking) -> Bool {
    switch (self, other) {
    case (.Ti, .ti):
      return true
    default:
      return false
    }
  }
  
  func fuse(other: Ticking) -> Ticking {
    switch (self, other) {
    case (.Ti, .Ti):
      return .Ti
    case (.ti, .ti):
      return .ti
    default:
      return .Ti
    }
  }
  
  var code: String {
    switch self {
    case .Ti:
      return "Ti"
    case .ti:
      return "ti"
    }
  }
}
