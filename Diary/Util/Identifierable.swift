//
//  Identifierable.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/14.
//

protocol Identifierable {
  static var identifier: String { get }
}

extension Identifierable {
  static var identifier: String {
    return String(describing: self)
  }
}
