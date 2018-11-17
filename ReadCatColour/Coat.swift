//
//  Coat.swift
//  ReadCatColour
//
//  Created by John Sandercock on 15/11/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Foundation

enum CatCoat: String, CustomStringConvertible {
  case black = "Black"
  case blue = "Blue"
  case brown = "Brown"
  case lilac = "Lilac"
  case cinnamon = "Cinnamon"
  case fawn = "Fawn"
  case red = "Red"
  case cream = "Cream"
  case white = "White"
  
  case seal = "Seal"
  case chocolate = "Chocolate"
  
  case blackTortie = "Black Tortie"
  case blueTortie = "Blue Tortie"
  case brownTortie = "Brown Tortie"
  case lilacTortie = "Lilac Tortie"
  case cinnamonTortie = "Cinnamon Tortie"
  case fawnTortie = "Fawn Tortie"
  
  case sealPoint = "Seal Point"
  case bluePoint = "Blue Point"
  case chocolatePoint = "Chocolate Point"
  case lilacPoint = "Lilac Point"
  case cinnamonPoint = "Cinnamon Point"
  case fawnPoint = "Fawn Point"
  case redPoint = "Red Point"
  case creamPoint = "Cream Point"
  
  case sealTortiePoint = "Seal Tortie Point"
  case blueTortiePoint = "Blue Tortie Point"
  case chocolateTortiePoint = "Chocolate Tortie Point"
  case lilacTortiePoint = "Lilac Tortie Point"
  case cinnamonTortiePoint = "Cinnamon Tortie Point"
  case fawnTortiePoint = "Fawn Tortie Point"
  
  case sealMink = "Seal Mink"
  case blueMink = "Blue Mink"
  case chocolateMink = "Chocolate Mink"
  case lilacMink = "Lilac Mink"
  case cinnamonMink = "Cinnamon Mink"
  case fawnMink = "Fawn Mink"
  case redMink = "Red Mink"
  case creamMink = "Cream Mink"
  
  case sealTortieMink = "Seal Tortie Mink"
  case blueTortieMink = "Blue Tortie Mink"
  case chocolateTortieMink = "Chocolate Tortie Mink"
  case lilacTortieMink = "Lilac Tortie Mink"
  case cinnamonTortieMink = "Cinnamon Tortie Mink"
  case fawnTortieMink = "Fawn Tortie Mink"
  
  case brownSepia = "Brown Sepia"
  case blueSepia = "Blue Sepia"
  case chocolateSepia = "Chocolate Sepia"
  case lilacSepia = "Lilac Sepia"
  case cinnamonSepia = "Cinnamon Sepia"
  case fawnSepia = "Fawn Sepia"
  case redSepia = "Red Sepia"
  case creamSepia = "Cream Sepia"
  
  case brownTortieSepia = "Brown Tortie Sepia"
  case blueTortieSepia = "Blue Tortie Sepia"
  case chocolateTortieSepia = "Chocolate Tortie Sepia"
  case lilacTortieSepia = "Lilac Tortie Sepia"
  case cinnamonTortieSepia = "Cinnamon Tortie Sepia"
  case fawnTortieSepia = "Fawn Tortie Sepia"
  
  case blueEyedAlbino = "Blue Eyed Albino"
  case pinkEyedAlbino = "Pink Eyed Albino"
  
  case none = "None"
  
  case tortie = "Tortie"
  
  case dense = "Dense"
  case dilute = "Dilute"
  
  case nonAgouti = "Non Agouti"
  case agouti = "Agouti"
  
  case gloved = "Mitted"
  
  case colorPoint = "Point"
  case sepia = "Sepia"
  case mink = "Mink"
  
  case van = "Van"
  case biColor = "Bi-Colour"
  
  case mackeral = "Mackeral Tabby"
  case classic = "Classic Tabby"
  
  case ticked = "Ticked Tabby"
  case moderatelyTicked = "Moderately Ticked"
  
  
  var description: String {
    return self.rawValue
  }
  
}

let pointedCats: [CatCoat] = [.sealPoint, .bluePoint, .chocolatePoint, .lilacPoint, .cinnamonPoint, .fawnPoint, .redPoint, .creamPoint, .sealTortiePoint, .blueTortiePoint, .chocolateTortiePoint, .lilacTortiePoint, .cinnamonTortiePoint, .fawnTortiePoint]

let minkCats: [CatCoat] = [.sealMink, .blueMink, .chocolateMink, .lilacMink, .cinnamonMink, .fawnMink, .redMink, .creamMink, .sealTortieMink, .blueTortieMink, .chocolateTortieMink, .lilacTortieMink, .cinnamonTortieMink, .fawnTortieMink]

let sepiaCats: [CatCoat] = [.brownSepia, .blueSepia, .chocolateSepia, .lilacSepia, .cinnamonSepia, .fawnSepia, .redSepia, .creamSepia, .brownTortieSepia, .blueTortieSepia, .chocolateTortieSepia, .lilacTortieSepia, .cinnamonTortieSepia, .fawnTortieSepia]

let tortieCats: [CatCoat] = [.blackTortie, .blueTortie, .brownTortie, .lilacTortie, .cinnamonTortie, .fawnTortie, .sealTortiePoint, .blueTortiePoint, .chocolateTortiePoint, .lilacTortiePoint, .cinnamonTortiePoint, .fawnTortiePoint, .sealTortieMink, .blueTortieMink, .chocolateTortieMink, .lilacTortieMink, .cinnamonTortieMink, .fawnTortieMink, .brownTortieSepia, .blueTortieSepia, .chocolateTortieSepia, .lilacTortieSepia, .cinnamonTortieSepia, .fawnTortieSepia]

let blackCats: [CatCoat] = [.black, .blackTortie, .sealPoint, .sealTortiePoint, .sealMink, .sealTortieMink, .brownSepia, .brownTortieSepia]

let brownCats: [CatCoat] = [.brown, .brownTortie, .chocolatePoint, .chocolateTortiePoint, .chocolateMink, .chocolateTortieMink, .chocolateSepia, .brownTortieSepia]

let blueCats: [CatCoat] = [.blue, .blueTortie, .bluePoint, .blueTortiePoint, .blueMink, .blueTortieMink, .blueSepia, .blueTortieSepia]

let lilacCats: [CatCoat] = [.lilac, .lilacTortie, .lilacPoint, .lilacTortiePoint, .lilacMink, .lilacTortieMink, .lilacSepia, .lilacTortieSepia]

let cinnamonCats: [CatCoat] = [.cinnamon, .cinnamonTortie, .cinnamonPoint, .cinnamonTortiePoint, .cinnamonMink, .cinnamonTortieMink, .cinnamonSepia, .cinnamonTortieSepia]

let fawnCats: [CatCoat] = [.fawn, .fawnTortie, .fawnPoint, .fawnTortiePoint, .fawnMink, .fawnTortieMink, .fawnSepia, .fawnTortieSepia]

let redCats: [CatCoat] = [.red, .redPoint, .redMink, .redSepia]

let creamCats: [CatCoat] = [.cream, .creamPoint, .creamMink, .creamSepia]
