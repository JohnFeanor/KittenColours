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
