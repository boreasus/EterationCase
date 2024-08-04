//
//  File.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import UIKit

final class TopAlignedLabel: UILabel {
  override func drawText(in rect: CGRect) {
    super.drawText(in: .init(
      origin: .zero,
      size: textRect(
        forBounds: rect,
        limitedToNumberOfLines: numberOfLines
      ).size
    ))
  }
}
