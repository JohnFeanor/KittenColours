//
//  PrintView.swift
//  KittenColours
//
//  Created by John Sandercock on 3/12/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Cocoa


private let boldFont = NSFont.boldSystemFont(ofSize: 18.0)
private let arial12 = NSFont(name: "ArialMT", size: 12.0) ?? NSFont.systemFont(ofSize: 12.0)
private let stdFontHeight = arial12.capHeight * 2.0
private let arialBold = NSFont(name: "Arial-BoldMT", size: 13.0) ?? NSFont.systemFont(ofSize: 12.0)
private let calibri12 = NSFont(name: "Calibri", size: 12.0) ?? NSFont.systemFont(ofSize: 12.0)

class PrintView: NSView {

  let sireCat: Cat
  let damCat: Cat
  
  let maleOffspring: [Offspring]
  let femaleOffspring: [Offspring]
  
  private var pageRect = NSRect()
  var linesPerPage = 0
  var currentPage = 0
  var currentCursorHeight: CGFloat = 0.0
  var currentOffspring = 0
  let numberMales: Int
  let numberFemales: Int
  let maxOffspring: Int
  
  
  init(sire: Cat, dam: Cat, maleOffspring: [Offspring], femaleOffspring: [Offspring]) {
    sireCat = sire
    damCat = dam
    
    self.maleOffspring = maleOffspring
    numberMales = self.maleOffspring.count
    self.femaleOffspring = femaleOffspring
    numberFemales = self.femaleOffspring.count
    maxOffspring = max(numberMales, numberFemales)
    
    super.init(frame: NSRect())
  }
  
  required init?(coder: NSCoder) {
    fatalError("PrintView cannot be instantiated from a nib")
  }
  
  // MARK: - Pagination
  override func knowsPageRange(_ range: NSRangePointer) -> Bool {
    
    let printOperation = NSPrintOperation.current!
    let printInfo = printOperation.printInfo
    
    // where can I draw
    pageRect = printInfo.imageablePageBounds
    let newFrame = NSRect(origin: CGPoint(), size: printInfo.paperSize)
    frame = newFrame
    
    // Construct the range to return
    var rangeOut = NSRange(location: 0, length: 0)
    
    // Pages are 1-based. That is the first page is page 1
    rangeOut.location = 1
    
    // How mant empty pages will it take?
    let docLength = maxOffspring * 18 + 218
    let pageLength = Int(pageRect.height)
    rangeOut.length = Int(docLength / pageLength)
    if docLength % pageLength > 0 {
      rangeOut.length += 1
    }
    
    // Return the newly constructed range, rangeOut, via the range pointer
    range.pointee = rangeOut
    
    return true
  }
  
  // the origin of the view is at the upper left corner
  override var isFlipped: Bool {
    return true
  }
  
  override func rectForPage(_ page: Int) -> NSRect {
    // Note the current page
    // Although Cocoa uses 1-based indexing for the page number
    // it's easier not to do that here
    currentPage = page - 1
    
    // return the same page rect every time
    return pageRect
  }
  
  override func draw(_ dirtyRect: NSRect) {
    
    func drawCentred(string: String, using font: NSFont, underlined: Bool = false) {
      let pageWidth = pageRect.maxX - pageRect.minX
      let stringSize = string.size(withAttributes: [NSAttributedString.Key.font : font])
      let boxWidth = min(stringSize.width, pageWidth)
      let startingX = (pageWidth - boxWidth) / 2.0
      
      let drawBox = NSRect(x: startingX, y: currentCursorHeight, width: boxWidth, height: stringSize.height)
      let attributes: [NSAttributedString.Key : Any] = underlined ? [NSAttributedString.Key.font : font, NSAttributedString.Key.underlineStyle : NSNumber(integerLiteral: 1)] : [NSAttributedString.Key.font : font]
      
      string.draw(in: drawBox, withAttributes: attributes)
    }
    
    func drawInBox(string: String, startingAt x: CGFloat = 0.0, withWidth width: CGFloat = 80.0, using font: NSFont, underlined: Bool = false) {
      let boxHeight = string.size(withAttributes: [NSAttributedString.Key.font : font]).height
      let startingX = pageRect.minX + x
      let drawBox = NSRect(x: startingX, y: currentCursorHeight, width: width, height: boxHeight)
      let attributes: [NSAttributedString.Key : Any] = underlined ? [NSAttributedString.Key.font : font, NSAttributedString.Key.underlineStyle : NSNumber(integerLiteral: 1)] : [NSAttributedString.Key.font : font]

      string.draw(in: drawBox, withAttributes: attributes)
    }
    
    func heightMultiplier(stringWidth: CGFloat, boxWidth: CGFloat) -> CGFloat {
      var multiplier = Int(stringWidth / boxWidth)
      if stringWidth.truncatingRemainder(dividingBy: boxWidth) > 0 {
        multiplier += 1
      }
      return CGFloat(multiplier)
    }
    
    func drawToEndOfLine(string: String, startingAt x: CGFloat = 0.0, using font: NSFont, underlined: Bool = false) -> CGFloat {
      let boxWidth = pageRect.maxX - pageRect.minX - x
      let stringSize = string.size(withAttributes: [NSAttributedString.Key.font : font])
      let boxHeight = stringSize.height * heightMultiplier(stringWidth: stringSize.width, boxWidth: boxWidth)
      let startingX = pageRect.minX + x
      let drawBox = NSRect(x: startingX, y: currentCursorHeight, width: boxWidth, height: boxHeight)
      let attributes: [NSAttributedString.Key : Any] = underlined ? [NSAttributedString.Key.font : font, NSAttributedString.Key.underlineStyle : NSNumber(integerLiteral: 1)] : [NSAttributedString.Key.font : font]

      string.draw(in: drawBox, withAttributes: attributes)
      return boxHeight
    }
    
    func drawtoHalfWay(string: String, startingAt x: CGFloat = 0.0, using font: NSFont, underlined: Bool = false) -> CGFloat {
      let startingX = pageRect.minX + x
      let boxWidth = (pageRect.maxX - pageRect.minX) / 2.0 - x - 10.0
      let stringSize = string.size(withAttributes: [NSAttributedString.Key.font : font])
      let boxHeight: CGFloat = stringSize.height * heightMultiplier(stringWidth: stringSize.width, boxWidth: boxWidth)
      drawInBox(string: string, startingAt: startingX, withWidth: boxWidth, using: font, underlined: underlined)

      return boxHeight
    }

    func drawtoHalfWay(kitten: Offspring, startingAt x: CGFloat = 0.0, using font: NSFont) -> CGFloat {
      let startX = pageRect.minX + x
      drawInBox(string: kitten.chance, startingAt: startX, withWidth: 65.0, using: font)
      let boxWidth = (pageRect.maxX - pageRect.minX) / 2.0 - x - 70.0
      let stringSize = kitten.colour.size(withAttributes: [NSAttributedString.Key.font : font])
      let boxHeight: CGFloat = stringSize.height * heightMultiplier(stringWidth: stringSize.width, boxWidth: boxWidth)
      let drawBox = NSRect(x: startX + 68.0, y: currentCursorHeight, width: boxWidth, height: boxHeight)
      let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font]

      kitten.colour.draw(in: drawBox, withAttributes: attributes)
      return boxHeight
    }
    
    func drawFromHalfWay(kitten: Offspring, using font: NSFont) -> CGFloat {
      let startX = (pageRect.maxX - pageRect.minX) / 2.0 + 4.0
      drawInBox(string: kitten.chance, startingAt: startX, withWidth: 65.0, using: font)
      return drawToEndOfLine(string: kitten.colour, startingAt: startX + 68.0 - pageRect.minX, using: font)
    }
    
    func drawFromHalfWay(string: String, using font: NSFont, underlined: Bool = false) -> CGFloat {
      let startX = (pageRect.maxX - pageRect.minX) / 2.0 + 10.0
      return drawToEndOfLine(string: string, startingAt: startX, using: font, underlined: underlined)
    }

    if currentPage == 0 {
      currentCursorHeight = pageRect.minY + 10.0
      drawCentred(string: "Possible results from a mating of", using: boldFont)
      currentCursorHeight += stdFontHeight * 2.0
      
      drawInBox(string: "Sire:", using: arialBold)
      let sireColour = sireCat.genome.colour
      currentCursorHeight += drawToEndOfLine(string: sireColour, startingAt: 40.0, using: calibri12) + 4.0
      
      drawInBox(string: "Carrying:", startingAt: 50.0, using: arialBold)
      let sireCarrying = sireCat.recessivesCarried.joined(separator: ", ")
      _ = drawToEndOfLine(string: sireCarrying, startingAt: 120.0, using: calibri12)
      currentCursorHeight += stdFontHeight * 1.25
      
      drawInBox(string: "Masking:", startingAt: 50.0, using: arialBold)
      let sireMasking = sireCat.colorsMasked.joined(separator: ", ")
      _ = drawToEndOfLine(string: sireMasking, startingAt: 120.0, using: calibri12)
      currentCursorHeight += stdFontHeight * 1.25
      
      drawCentred(string: "with", using: arial12, underlined: true)
      currentCursorHeight += stdFontHeight * 1.25
      
      drawInBox(string: "Dam:", using: arialBold)
      let damColour = damCat.genome.colour
      currentCursorHeight += drawToEndOfLine(string: damColour, startingAt: 40.0, using: calibri12) + 4.0
      
      drawInBox(string: "Carrying:", startingAt: 50.0, using: arialBold)
      let damCarrying = damCat.recessivesCarried.joined(separator: ", ")
      _ = drawToEndOfLine(string: damCarrying, startingAt: 120.0, using: calibri12)
      currentCursorHeight += stdFontHeight * 1.25
      
      drawInBox(string: "Masking:", startingAt: 50.0, using: arialBold)
      let damMasking = damCat.colorsMasked.joined(separator: ", ")
      _ = drawToEndOfLine(string: damMasking, startingAt: 120.0, using: calibri12)
      currentCursorHeight += stdFontHeight * 1.5
      
      _ = drawtoHalfWay(string: "Male Offspring", using: arial12, underlined: true)
      currentCursorHeight += drawFromHalfWay(string: "Female Offspring", using: arial12, underlined: true) + 4.0

      currentOffspring = 0
      while currentCursorHeight <= pageRect.height {
        if currentOffspring >= maxOffspring {
          break
        }
        let maleTextHeight: CGFloat
        let femaleTextHeight: CGFloat
        if currentOffspring < numberMales {
          maleTextHeight = drawtoHalfWay(kitten: maleOffspring[currentOffspring], using: calibri12)
        } else {
          maleTextHeight = 0.0
        }
        
        if currentOffspring < numberFemales {
          femaleTextHeight = drawFromHalfWay(kitten: femaleOffspring[currentOffspring], using: calibri12)
        } else {
          femaleTextHeight = 0.0
        }
        currentOffspring += 1
        currentCursorHeight += max(maleTextHeight, femaleTextHeight)
      }

    } else {
      currentCursorHeight = pageRect.minY + 10.0
      _ = drawtoHalfWay(string: "Male Offspring (Cont)", using: arial12, underlined: true)
      currentCursorHeight += drawFromHalfWay(string: "Female Offspring (Cont)", using: arial12, underlined: true) + 4.0
      
      while currentCursorHeight <= pageRect.height {
        if currentOffspring >= maxOffspring {
          break
        }
        let maleTextHeight: CGFloat
        let femaleTextHeight: CGFloat
        if currentOffspring < numberMales {
          maleTextHeight = drawtoHalfWay(kitten: maleOffspring[currentOffspring], using: calibri12)
        } else {
          maleTextHeight = 0.0
        }
        
        if currentOffspring < numberFemales {
          femaleTextHeight = drawFromHalfWay(kitten: femaleOffspring[currentOffspring], using: calibri12)
        } else {
          femaleTextHeight = 0.0
        }
        currentOffspring += 1
        currentCursorHeight += max(maleTextHeight, femaleTextHeight)
      }
    }
    
  }
}
