//
//  Box.swift
//  Publisher
//
//  Created by Wayne Chen on 2020/11/20.
//

import Foundation

/**
 From raywenderlich: https://www.raywenderlich.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc#toc-anchor-008
 */
final class Box<T> {
  // 1
  typealias Listener = (T) -> Void
  var listener: Listener?
  // 2
  var value: T {
    didSet {
      listener?(value)
    }
  }
  // 3
  init(_ value: T) {
    self.value = value
  }
  // 4
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
