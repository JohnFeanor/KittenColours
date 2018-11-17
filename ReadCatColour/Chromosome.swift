//
//  Allele.swift
//  CatColours2
//
//  Created by John Sandercock on 11/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Foundation

struct Chromosome {
  var pigment: Pair<Pigment> = Pair(.B)
  var density: Pair<Density> = Pair(.dense)
  var orange: Pair<Orange> = Pair(.o)
  var agouti: Pair<Agouti> = Pair(.a)
  var white: Pair<White> = Pair(.notWhite)
  var gloving: Pair<Gloving> = Pair(.none)
  var albinism: Pair<Albinism> = Pair(.C)
  var spotting: Pair<Spotting> = Pair(.s)
  var tabby: Pair<Tabby> = Pair(.Mc)
  var ticking: Pair<Ticking> = Pair(.ti)
  
  var baseColor: CatCoat {
    switch density.expression {
    case .dense:
      if orange.expression == .red { return CatCoat.red }
      switch pigment.expression {
      case .B:
        switch albinism.expression {
        case .colorPoint, .mink:
          return CatCoat.seal
        case .sepia:
          return CatCoat.brown
        default:
          return CatCoat.black
        }
      case .b:
        switch albinism.expression {
        case .colorPoint, .mink, .sepia:
          return CatCoat.chocolate
        default:
          return CatCoat.brown
        }
      case .b1:
        return CatCoat.cinnamon
      }
    case .dilute:
      if orange.expression == .red { return CatCoat.cream }
      switch pigment.expression {
      case .B:
        return CatCoat.blue
      case .b:
        return CatCoat.lilac
      case .b1:
        return CatCoat.fawn
      }
    }
  }
  
  mutating func tortie() {
    orange[1] = .O
    orange[2] = .o
  }
  mutating func black() {
    pigment[1] = .B
    density[1] = .dense
  }
  mutating func blue() {
    pigment[1] = .B
    density.limit(with: .dilute)
  }
  mutating func brown() {
    pigment.limit(with: .b)
    density[1] = .dense
  }
  mutating func lilac() {
    pigment.limit(with: .b)
    density.limit(with: .dilute)
  }
  mutating func cinnamon() {
    pigment.limit(with: .b1)
    density[1] = .dense
  }
  mutating func fawn() {
    pigment.limit(with: .b1)
    density.limit(with: .dilute)
  }
  mutating func red() {
    orange[1] = .O
    if orange[2] == .o { orange[2] = .O }
    density[1] = .dense
  }
  mutating func cream() {
    orange[1] = .O
    if orange[2] == .o { orange[2] = .O }
    density.limit(with: .dilute)
 }
  mutating func point() {
    albinism.fill(with: .cs)
  }
  mutating func sepia() {
    albinism.fill(with: .cb)
  }
  mutating func mink() {
    albinism[1] = .cs
    albinism[2] = .cb
  }
  
  var colour: String {
    var ans: String
    if white.expression.active { return CatCoat.white.description }
    let colorRestriction = albinism.expression
    switch colorRestriction {
    case .blueEyedAlbino, .pinkEyedAlbino:
      return colorRestriction.description
    default:
      ans = baseColor.description
    }
    
    if orange.expression == .tortie {
      ans += " \(CatCoat.tortie)"
    }

      ans += " \(gloving.expression.description)"
    
    if agouti.expression.active {
      if ticking.expression.active { ans += " \(CatCoat.ticked)" }
      else { ans += " \(tabby.expression.description)" }
    }

    ans += " \(colorRestriction.description)"
    ans += " \(spotting.expression.description)"
    
    return ans
  }
}
