//
//  Identifierable.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/16
//

import Foundation

protocol Identifiable {
  static var identifier: String { get }
}

extension Identifiable {
  static var identifier: String {
    return String(describing: self)
  }
}
