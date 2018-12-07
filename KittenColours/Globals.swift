//
//  Globals.swift
//  ReadCatColour
//
//  Created by John Sandercock on 15/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Foundation

enum ParameterError: Error {
  case nilValue
  case incorrectValue(value: String)
}

extension Array {
  public subscript(safe index: Int) -> Element? {
    guard index >= 0, index < endIndex else {
      return nil
    }
    
    return self[index]
  }
}

// Recursive

func gcdr (_ dividend: Int, _ divisor: Int) -> Int {
  var a = abs(dividend); var b = abs(divisor)
  if (b > a) { swap(&a, &b) }
  return gcd_rec(a,b)
}

private func gcd_rec(_ a: Int, _ b: Int) -> Int {
  return b == 0 ? a : gcd_rec(b, a % b)
}

func set(flag:  inout Bool, to: Bool) {
  if to != flag {
    flag = to
  }
}
