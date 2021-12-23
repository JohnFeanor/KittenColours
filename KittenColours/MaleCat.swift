//
//  MaleCat.swift
//  ReadCatColour
//
//  Created by John Sandercock on 14/11/18.
//  Copyright © 2021 Feanor. All rights reserved.
//

import Foundation

class MaleCat: Cat {

  override var sex: Sex{
    return .male
  }
  
  override init() {
    super.init()
    self.genome.orange[2] = .none
  }
  
  override func awakeFromNib() {
    colorMenuItems = [.black, .blue, .brown, .lilac, .cinnamon, .fawn, .red, .cream, .sealPoint, .bluePoint, .chocolatePoint, .lilacPoint, .cinnamonPoint, .fawnPoint, .redPoint, .creamPoint, .sealMink, .blueMink, .chocolateMink, .lilacMink, .cinnamonMink, .fawnMink, .redMink, .creamMink, .brownSepia, .blueSepia, .chocolateSepia, .lilacSepia, .cinnamonSepia, .fawnSepia, .redSepia, .creamSepia, .white]
    self.genome.orange[2] = .none
    super.awakeFromNib()
  }
}
