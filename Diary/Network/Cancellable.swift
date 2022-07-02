//
//  Cancellable.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/29.
//

import Foundation

protocol Cancellable {
  func suspend()
  func cancel()
}
