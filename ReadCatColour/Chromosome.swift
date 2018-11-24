//
//  Allele.swift
//  CatColours2
//
//  Created by John Sandercock on 11/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Foundation

public struct Chromosome: CustomStringConvertible {
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
  
  public var description: String {
    return "\(pigment) \(density) \(orange) \(agouti) \(white) \(gloving) \(albinism) \(spotting) \(tabby) \(ticking)"
  }
  
  var male: Bool {
    if orange[1] == .none { return true }
    if orange[2] == .none { return true }
    return false
  }
  
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
  mutating func black(dilute: Bool, pigment p: Bool) {
    pigment.limit(with: .B, allowingRecessives: p)
    density.limit(with: .dense, allowingRecessives: dilute)
  }
  mutating func blue(pigment p: Bool) {
    pigment.limit(with: .B, allowingRecessives: p)
    density.fill(with: .dilute)
  }
  mutating func brown(dilute: Bool, pigment p: Bool) {
    pigment.limit(with: .b, allowingRecessives: p)
    density.limit(with: .dense, allowingRecessives: dilute)
  }
  mutating func lilac(pigment p: Bool) {
    pigment.limit(with: .b, allowingRecessives: p)
    density.fill(with: .dilute)
  }
  mutating func cinnamon(dilute: Bool) {
    pigment.fill(with: .b1)
    density.limit(with: .dense, allowingRecessives: dilute)
  }
  mutating func fawn() {
    pigment.fill(with: .b1)
    density.fill(with: .dilute)
  }
  mutating func red(sex: Sex, dilute: Bool, pigment p: Bool) {
    orange[1] = .O
    if sex == .male {
      orange[2] = .none
    } else  {
      orange[2] = .O
    }
    self.black(dilute: dilute, pigment: p)
  }
  mutating func cream(sex: Sex, pigment p: Bool) {
    orange[1] = .O
    if sex == .male {
      orange[2] = .none
    } else  {
      orange[2] = .O
    }
    self.blue(pigment: p)
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
