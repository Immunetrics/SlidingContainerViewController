//
//  SlidingContainerPage.swift
//  SlidingContainerViewController
//
//  Created by Justin Wright on 10/27/17.
//  Copyright © 2017 Cem Olcay. All rights reserved.
//

import UIKit


fileprivate enum Constants {
  static let warning = "Please set contentCreator:SlidingContainerContentCreator by calling 'set(contentCreator:)' before using the SlidingContainerPage."
}


public protocol SlidingContainerPage {
  
  static var contentCreator: SlidingContainerContentCreator! { get set }
  
  static func set(contentCreator newValue: SlidingContainerContentCreator)
  static func cleanup()
}

extension SlidingContainerPage {
  
  public static var titles: [String] {
    precondition(contentCreator != nil, Constants.warning)
    return contentCreator.titles
  }
  
  public static var pages: [String : UIViewController] {
    precondition(contentCreator != nil, Constants.warning)
    return contentCreator.pages
  }
  
  public static func set(contentCreator newValue: SlidingContainerContentCreator) {
    contentCreator = newValue
  }
  
  public static func cleanup() { contentCreator = nil }
}


public protocol SlidingContainerContentCreator {
  
  var pages: [String: UIViewController] { get set }
  var titles: [String] { get set }
  
}




