//
//  FemaleCat.swift
//  ReadCatColour
//
//  Created by John Sandercock on 16/11/18.
//  Copyright © 2021 Feanor. All rights reserved.
//

import Foundation

class FemaleCat: Cat {
  
  override var sex: Sex{
    return .female
  }
  
  
  override func awakeFromNib() {
    colorMenuItems = [.black, .blue, .brown, .lilac, .cinnamon, .fawn, .red, .cream, .blackTortie, .blueTortie, .brownTortie, .lilacTortie, .cinnamonTortie, .fawnTortie, .sealPoint, .bluePoint, .chocolatePoint, .lilacPoint, .cinnamonPoint, .fawnPoint, .redPoint, .creamPoint, .sealTortiePoint, .blueTortiePoint, .chocolateTortiePoint, .lilacTortiePoint, .cinnamonTortiePoint, .fawnTortiePoint, .sealMink, .blueMink, .chocolateMink, .lilacMink, .cinnamonMink, .fawnMink, .redMink, .creamMink, .sealTortieMink, .blueTortieMink, .chocolateTortieMink, .lilacTortieMink, .cinnamonTortieMink, .fawnTortieMink, .brownSepia, .blueSepia, .chocolateSepia, .lilacSepia, .cinnamonSepia, .fawnSepia, .redSepia, .creamSepia, .brownTortieSepia, .blueTortieSepia, .chocolateTortieSepia, .lilacTortieSepia, .cinnamonTortieSepia, .fawnTortieSepia, .white]
   super.awakeFromNib()
  }
  
}
