//
//  Pair.swift
//  CatColours2
//
//  Created by John Sandercock on 11/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Foundation

/// A pair of genes
///
/// These are accessed by subscripting 1 & 2
struct Pair<T> where T: Gene {
  var first: T
  var second: T
  
  var expression: T.Trait {
    return first.fuse(other: second)
  }
  
  init(_ first: T, _ second: T? = nil) {
    self.first = first
    self.second = second ?? first
  }
  
  /// - first gene becomes `element`
  /// - if second gene dominates `element`, second gene also becomes `element`
  mutating func limit(with element: T) {
    self.first = element
    if self.second.dominates(other: element) {
      self.second = element
    }
  }
  /// - first and second genes both become `element`
  mutating func fill(with element: T) {
    self.first = element
    self.second = element
  }
  
  /// ### NOTE: ###
  /// only subscripts allowed are `1` and `2`
  ///
  /// all others cause a fatal error
  subscript(index: Int) -> T {
    get {
      switch index {
      case 1:
        return first
      case 2:
        return second
      default:
        fatalError("Index out of bounds")
      }
    }
    set {
      switch index {
      case 1:
        first = newValue
      case 2:
        second = newValue
      default:
        fatalError("Index out of bounds")
      }
    }
  }
}


