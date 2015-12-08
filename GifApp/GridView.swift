//
//  GridView.swift
//  GifApp
//
//  Created by 朱坤 on 12/7/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class GridView: UICollectionView {
  var images: [String]?
  
  override func sizeThatFits(size: CGSize) -> CGSize {
    return imageSize()
  }
  
  private func imageSize() -> CGSize{
    let itemSize = CGSize(width: 115, height: 150)
    var height: CGFloat = 0
    let width: CGFloat = 700
    if let images = images{
      let num = images.count
      height = getRows(num)*(itemSize.height)
      if (num > 0){ print("\(num) is , \(getRows(num)), height is \(height)") }
      if (num == 1){ height = 360 }
    }
    return CGSize(width: width, height: height)
  }
  
  private func getRows(num: Int) -> CGFloat{
    let remainder = num % 3
    let row = num / 3
    if remainder != 0 {
      return CGFloat(row + 1)
    }
    return CGFloat(row)
  }
}