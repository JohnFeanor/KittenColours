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
private let calibri12Height = calibri12.capHeight * 2.0

class PrintView: NSView {

//  @IBOutlet weak var printMaleOffspringTextField: NSTextField!
//  @IBOutlet weak var printFemaleOffspringTextField: NSTextField!
//
//  @IBOutlet weak var printSireColorTextField: NSTextField!
//  @IBOutlet weak var printDamColorTextField: NSTextField!
//  @IBOutlet weak var printSireCarryingTextField: NSTextField!
//  @IBOutlet weak var printSireMaskingTextField: NSTextField!
//  @IBOutlet weak var printDamCarryingTextField: NSTextField!
//  @IBOutlet weak var printDamMaskingTextField: NSTextField!
//  @IBOutlet weak var maleLabel: NSTextField!
//
//  @IBOutlet weak var maleOffspringTextField: NSTextField!
//  @IBOutlet weak var femaleOffspringTextField: NSTextField!
//
//  @IBOutlet weak var sireCat: MaleCat!
//  @IBOutlet weak var damCat: FemaleCat!
  
  let sireCat: Cat
  let damCat: Cat
  
  let maleOffspring: [String]
  let femaleOffspring: [String]
  
  private var pageRect = NSRect()
  var linesPerPage = 0
  var currentPage = 0
  var currentCursorHeight: CGFloat = 0.0
  var currentOffspring = 0
  let numberMales: Int
  let numberFemales: Int
  let maxOffspring: Int
  
  
  init(sire: Cat, dam: Cat, maleOffspring: String, femaleOffspring: String) {
    sireCat = sire
    damCat = dam
    
    self.maleOffspring = Array<String>(maleOffspring.components(separatedBy: "\n").dropLast())
    numberMales = self.maleOffspring.count
    self.femaleOffspring = Array<String>(femaleOffspring.components(separatedBy: "\n").dropLast())
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
    
    func draw(string: String, using font: NSFont, centered: Bool = false, inset: Int = 0, underlined: Bool = false) -> CGFloat {
      let size = string.size(withAttributes: [NSAttributedString.Key.font : font])
      let yValue = currentCursorHeight - font.capHeight + size.height / 2.0
      
      let thePoint: NSPoint
      let box: NSRect
      if centered {
        thePoint = NSPoint(x: (pageRect.minX + pageRect.maxX) / 2.0 - size.width / 2.0, y: currentCursorHeight)
      } else {
        let x: CGFloat
        switch inset {
        case 0:
          x = pageRect.minX + 10
        case 1:
          x = pageRect.minX + 50.0
        case 2:
          x = pageRect.minX + 110.0
        case 3:
          x = pageRect.minX + 175.0
        default:
          let indent = CGFloat(inset * 50)
          x = pageRect.minX + indent
        }
        thePoint = NSPoint(x: x, y: yValue)
      }
      box = NSRect(origin: thePoint, size: size)
      let attributes: [NSAttributedString.Key : Any] = underlined ? [NSAttributedString.Key.font : font, NSAttributedString.Key.underlineStyle : NSNumber(integerLiteral: 1)] : [NSAttributedString.Key.font : font]

     string.draw(in: box, withAttributes: attributes)
      return size.height
    }

    if currentPage == 0 {
      currentCursorHeight = pageRect.minY + 10.0
      _ = draw(string: "Possible results from a mating of", using: boldFont, centered: true)
      
      currentCursorHeight += stdFontHeight * 2.0
      _ = draw(string: "Sire:", using: arialBold)
      let sireColour = sireCat.genome.colour
      _ = draw(string: sireColour, using: calibri12, inset: 1)
      
      currentCursorHeight += stdFontHeight * 1.25
      _ = draw(string: "Carrying:", using: arial12, inset: 1)
      let sireCarrying = sireCat.recessivesCarried.joined(separator: ", ")
      _ = draw(string: sireCarrying, using: calibri12, inset: 2)
      
      currentCursorHeight += stdFontHeight * 1.25
      _ = draw(string: "Masking:", using: arial12, inset: 1)
      let sireMasking = sireCat.colorsMasked.joined(separator: ", ")
      _ = draw(string: sireMasking, using: calibri12, inset: 2)
      
      currentCursorHeight += stdFontHeight * 1.25
      _ = draw(string: "with", using: arial12, centered: true, underlined: true)
      
      currentCursorHeight += stdFontHeight * 1.25
      _ = draw(string: "Dam:", using: arialBold)
      let damColour = damCat.genome.colour
      _ = draw(string: damColour, using: calibri12, inset: 1)
      
      currentCursorHeight += stdFontHeight * 1.25
      _ = draw(string: "Carrying:", using: arial12, inset: 1)
      let damCarrying = damCat.recessivesCarried.joined(separator: ", ")
      _ = draw(string: damCarrying, using: calibri12, inset: 2)
      
      currentCursorHeight += stdFontHeight * 1.25
      _ = draw(string: "Masking:", using: arial12, inset: 1)
      let damMasking = damCat.colorsMasked.joined(separator: ", ")
      _ = draw(string: damMasking, using: calibri12, inset: 2)
      
      currentCursorHeight += stdFontHeight * 2.0
      _ = draw(string: "Male Offspring", using: arial12, inset: 1, underlined: true)
      _ = draw(string: "Female Offspring", using: arial12, inset: 6, underlined: true)

      currentCursorHeight += stdFontHeight * 1.25
      currentOffspring = 0
      while currentCursorHeight <= pageRect.height {
        if currentOffspring >= maxOffspring {
          break
        }
        var increment: CGFloat = 0.0
        if currentOffspring <= numberMales {
          increment = draw(string: maleOffspring[currentOffspring], using: calibri12, inset: 1)
        }
        if currentOffspring <= numberFemales {
          increment = draw(string: femaleOffspring[currentOffspring], using: calibri12, inset: 6)
        }
        currentOffspring += 1
        currentCursorHeight += increment
      }

    } else {
      currentCursorHeight = pageRect.minY + 10.0
      _ = draw(string: "Male Offspring (Cont)", using: arial12, inset: 1, underlined: true)
      _ = draw(string: "Female Offspring (Cont)", using: arial12, inset: 6, underlined: true)
      
      currentCursorHeight += stdFontHeight * 1.25

      while currentCursorHeight <= pageRect.height {
        if currentOffspring >= maxOffspring {
          break
        }
        var increment: CGFloat = 0.0
        if currentOffspring < numberMales {
          increment = draw(string: maleOffspring[currentOffspring], using: calibri12, inset: 1)
        }
        if currentOffspring < numberFemales {
          increment = draw(string: femaleOffspring[currentOffspring], using: calibri12, inset: 6)
        }
        currentOffspring += 1
        currentCursorHeight += increment
      }
    }
    
  }
}
