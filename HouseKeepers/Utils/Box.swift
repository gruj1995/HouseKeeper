//
//  Box.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/22.
//

import Foundation


final class Box<T> {
    
  // 每個Box都會有一個Listener，當值被更改了就會通知Box。
  typealias Listener = (T) -> Void
  var listener: Listener?
     
  // Box具有泛型值, 當didSet觀察到任何的更改，就會通知Listener。
  var value: T {
    didSet {
      listener?(value)
    }
  }

  init(_ value: T) {
    self.value = value
  }
    
  // 當一個Listener在Box上調用bind(listener:)時，它會成為Listener，並且立即得到Box的當前值的通知。
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
