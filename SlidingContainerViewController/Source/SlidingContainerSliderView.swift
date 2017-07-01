//
//  SlidingContainerSliderView.swift
//  SlidingContainerViewController
//
//  Created by Cem Olcay on 10/04/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

public protocol SlidingContainerSliderViewDelegate: class {
  func slidingContainerSliderViewDidPressed (_ slidingtContainerSliderView: SlidingContainerSliderView, atIndex: Int)
}

public class SlidingContainerSliderView: UIScrollView, UIScrollViewDelegate {
  public static let sliderHeight: CGFloat = 48
  
  public var shouldSlide: Bool = true
  public var sliderHeight: CGFloat = SlidingContainerSliderView.sliderHeight
  public var titles: [String]!
  public var labels: [UILabel] = []
  public var selector: UIView!
  public weak var sliderDelegate: SlidingContainerSliderViewDelegate?
  
  public var appearance: SlidingContainerSliderViewAppearance! {
    didSet {
      draw()
    }
  }
  
  // MARK: Init
  
  public init(width: CGFloat, titles: [String]) {
    super.init(frame: CGRect (x: 0, y: 0, width: width, height: sliderHeight))
    self.titles = titles
    
    delegate = self
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
    scrollsToTop = false
    
    self.addGestureRecognizer(UITapGestureRecognizer (
      target: self,
      action: #selector(SlidingContainerSliderView.didTap(_:))))
    
    appearance = SlidingContainerSliderViewAppearance (
      backgroundColor: UIColor(white: 0, alpha: 0.3),
      font: UIFont (name: "HelveticaNeue-Light", size: 15)!,
      selectedFont: UIFont.systemFont(ofSize: 15),
      textColor: UIColor.darkGray,
      selectedTextColor: UIColor.white,
      outerPadding: 10,
      innerPadding: 10,
      selectorColor: UIColor.red,
      selectorHeight: 5,
      fixedWidth: false)
    
    draw()
    drawShadow()
  }
  
  public func drawLine() {
    let frame: CGRect = bounds
    let layer: CAShapeLayer = CAShapeLayer()
    
    layer.lineWidth = 1
    layer.strokeColor = UIColor(hex: 0xE0E0E0).cgColor
    layer.fillColor = nil
    
    let start = CGPoint(x: 0, y: bounds.height + 0.5)
    let end = CGPoint(x: frame.width, y: bounds.height + 0.5)
    
    let path = UIBezierPath()
    path.move(to: start)
    path.addLine(to: end)
    layer.path = path.cgPath
    layer.masksToBounds = false
    self.layer.addSublayer(layer)
    self.layer.masksToBounds = false
    self.clipsToBounds = false
  }
  
  public func drawShadow() {
    let shadowOffset: CGSize = CGSize(width: 0, height: 4)
    let shadowOpacity: Float = 0.1
    let shadowRadius: CGFloat = 3.0
    
    layer.shadowRadius = shadowRadius
    layer.shadowOpacity = shadowOpacity
    layer.shadowOffset = shadowOffset
    layer.masksToBounds = false
    layer.shouldRasterize = true
    layer.drawsAsynchronously = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  public required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  // MARK: Draw
  
  public func draw() {
    // clean
    if labels.count > 0 {
      for label in labels {
        label.removeFromSuperview()
        if selector != nil {
          selector.removeFromSuperview()
          selector = nil
        }
      }
    }
    
    labels = []
    backgroundColor = appearance.backgroundColor
    
    if appearance.fixedWidth {
      
      var labelTag = 0
      let width = CGFloat(frame.size.width) / CGFloat(titles.count)
      
      for title in titles {
        let label = labelWithTitle(title)
        label.frame.origin.x = (width * CGFloat(labelTag))
        label.frame.size = CGSize(width: width, height: label.frame.size.height)
        label.center.y = frame.size.height/2
        labelTag += 1
        label.tag = labelTag
        
        addSubview(label)
        labels.append(label)
      }
      
      let selectorH = appearance.selectorHeight
      selector = UIView (frame: CGRect (x: 0, y: frame.size.height - selectorH, width: width, height: selectorH))
      selector.backgroundColor = appearance.selectorColor
      addSubview(selector)
      
      contentSize = CGSize (width: frame.size.width, height: frame.size.height)
    } else {
      
      var labelTag = 0
      var currentX = appearance.outerPadding
      
      for title in titles {
        let label = labelWithTitle(title)
        label.frame.origin.x = currentX
        label.center.y = frame.size.height/2
        labelTag += 1
        label.tag = labelTag
        addSubview(label)
        labels.append(label)
        currentX += label.frame.size.width + appearance.outerPadding
      }
      
      let selectorH = appearance.selectorHeight
      selector = UIView (frame: CGRect (x: 0, y: frame.size.height - selectorH, width: 100, height: selectorH))
      selector.backgroundColor = appearance.selectorColor
      addSubview(selector)
      
      contentSize = CGSize (width: currentX, height: frame.size.height)
    }
  }
  
  public func labelWithTitle(_ title: String) -> UILabel {
    let label = UILabel (frame: .zero)
    label.text = title
    label.font = appearance.font
    label.textColor = appearance.textColor
    label.textAlignment = .center
    label.sizeToFit()
    label.frame.size.width += appearance.innerPadding * 2
    label.isUserInteractionEnabled = true
    return label
  }
  
  // MARK: Actions
  
  public func didTap(_ tap: UITapGestureRecognizer) {
    let view = tap.view
    let loc = tap.location(in: view)
    
    let tags: [Int] = self.labels.reduce([]){ result, label in
      
      let frame = CGRect(x: label.frame.origin.x,
                         y: 0,
                         width: label.frame.width,
                         height: SlidingContainerSliderView.sliderHeight)
      
      if frame.contains(loc){
        return result + [label.tag]
      }
      return result
    }
    
    if let tag = tags.first {
      self.sliderDelegate?.slidingContainerSliderViewDidPressed(self, atIndex: tag - 1)
    }
  }
  
  // MARK: Menu
  
  public func selectItemAtIndex(_ index: Int, animated: Bool = true) {
    // Set Labels
    for i in 0..<self.labels.count {
      let label = labels[i]
      
      if i == index {
        
        label.textColor = appearance.selectedTextColor
        label.font = appearance.selectedFont
        
        if !appearance.fixedWidth {
          label.sizeToFit()
          label.frame.size.width += appearance.innerPadding * 2
        }
        
        let duration: TimeInterval = animated ? 0.5 : 0.0
        
        
        // Set selector
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.77, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
          [unowned self] in
          self.selector.frame = CGRect (
            x: label.frame.origin.x,
            y: self.selector.frame.origin.y,
            width: label.frame.size.width,
            height: self.appearance.selectorHeight)
          }, completion: nil)
        
        
        
      } else {
        label.textColor = appearance.textColor
        label.font = appearance.font
        if !appearance.fixedWidth {
          label.sizeToFit()
          label.frame.size.width += appearance.innerPadding * 2
        }
      }
    }
  }
}

extension UIColor {
  
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Bad red component")
    assert(green >= 0 && green <= 255, "Bad green component")
    assert(blue >= 0 && blue <= 255, "Bad blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(hex:Int) {
    self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
  }
}
