//
//  SlidingContainerSliderViewAppearance.swift
//  SlidingContainerViewController
//
//  Created by Justin Wright on 6/26/17.
//  Copyright © 2017 Cem Olcay. All rights reserved.
//

import UIKit

public struct SlidingContainerSliderViewAppearance {
  public var backgroundColor: UIColor
  public var font: UIFont
  public var selectedFont: UIFont
  public var textColor: UIColor
  public var selectedTextColor: UIColor
  public var outerPadding: CGFloat
  public var innerPadding: CGFloat
  public var selectorColor: UIColor
  public var selectorHeight: CGFloat
  public var fixedWidth: Bool
  
  public init(backgroundColor: UIColor, font: UIFont, selectedFont: UIFont, textColor: UIColor, selectedTextColor: UIColor, outerPadding: CGFloat, innerPadding: CGFloat, selectorColor: UIColor, selectorHeight: CGFloat, fixedWidth: Bool) {
    
    self.backgroundColor = backgroundColor
    self.font = font
    self.selectedFont = selectedFont
    self.textColor = textColor
    self.selectedTextColor = selectedTextColor
    self.outerPadding = outerPadding
    self.innerPadding = innerPadding
    self.selectorColor = selectorColor
    self.selectorHeight = selectorHeight
    self.fixedWidth = fixedWidth
  }
}
