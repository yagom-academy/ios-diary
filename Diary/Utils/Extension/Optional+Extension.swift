//
//  Optional+.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/22.
//

import Foundation

extension Optional where Wrapped == String {
  func bindOptional() -> String {
    guard let bind = self else {
      return ""
    }
    
    return bind
  }
}

extension Optional where Wrapped == Date {
  func bindOptional() -> Date {
    guard let bind = self else {
      return Date()
    }
    
    return bind
  }
}
