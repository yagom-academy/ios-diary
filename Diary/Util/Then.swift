//
//  Then.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/17.
//

import Foundation

protocol Then {}

extension Then where Self: AnyObject {
  func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)

    return self
  }
}

extension NSObject: Then {}
