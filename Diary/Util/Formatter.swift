//
//  Formatter.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/17.
//

import Foundation

enum Formatter {
  private static let dateFormatter = DateFormatter()

  static func changeToString(from timeInterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeInterval)
    self.dateFormatter.dateStyle = .long
    self.dateFormatter.locale = Locale.current
    self.dateFormatter.timeZone = TimeZone.current

    return self.dateFormatter.string(from: date)
  }
}
