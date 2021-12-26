//
//  Globals.swift
//  ReadCatColour
//
//  Created by John Sandercock on 15/11/18.
//  Copyright © 2021 Feanor. All rights reserved.
//

import SwiftUI

// MARK: Helper functions for error handling
fileprivate func log(_ items: [Any], separator: String = " ", terminator: String = "\n", marker: String, file: String, function: String, line: Int) {
  let lastSlashIndex = (file.lastIndex(of: "/") ?? String.Index(utf16Offset: 0, in: file))
  let nextIndex = file.index(after: lastSlashIndex)
  let filename = file.suffix(from: nextIndex).replacingOccurrences(of: ".swift", with: "")
  
  let prefix = "\(marker) \(filename).\(function):\(line)"
  
  let message = items.map {"\($0)"}.joined(separator: separator)
  print("\(prefix) \(message)", terminator: terminator)
}

func errormsg(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
  log(items, separator: separator, terminator: terminator, marker: "😢", file: file, function: function, line: line)
}

enum ParameterError: Error {
  case nilValue
  case incorrectValue(value: String)
}

extension Array where Element == Offspring {
  internal subscript(safe index: Int) -> Element {
    guard index >= 0, index < endIndex else {
      return Offspring(chance: "", colour: "")
    }
    
    return self[index]
  }
}

extension Array {
  internal subscript(safe index: Int) -> Element? {
    guard index >= 0, index < endIndex else {
      return nil
    }
    return self[index]
  }
}

// MARK: functions to convert types into and from Data
protocol Datamaker {
  var data: Data {get }
}

extension String: Datamaker {
  var data: Data {
    if let ans = self.data(using: String.Encoding.utf8) {
      return ans
    } else {
      fatalError("Cannot encode \"\(self)\"")
    }
  }
}

extension Data {
  mutating func add(data: Datamaker ...) {
    for datum in data {
      self.append(datum.data)
    }
  }
}

extension Data {
  var string: NSAttributedString {
    let s: NSAttributedString
    do {
      s = try NSAttributedString(data: self, documentAttributes: nil)
    } catch {
      return NSAttributedString(string: "🌩")
    }
    return s
  }
}

// Recursive

/// A recursive function to return the greatest common divisor of two integers
/// - Returns: an integer which is the greatest common divisor of *dividend* and *divisor*
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

// MARK: Function to read in files from the Bundle

/// Reads the file given as a parameter from the Bundle
/// - Parameter filename: String giving the name of the file to be read in
func readFile(_ fileName: String) -> Data {
  let path = Bundle.main.path(forResource: fileName, ofType: "txt")
  
  if let path = path {
    let d = FileManager.default.contents(atPath: path)
    if let d = d {
      return d
    }
  }
  fatalError("Cannot read data from \"\(fileName).txt\"")
}

