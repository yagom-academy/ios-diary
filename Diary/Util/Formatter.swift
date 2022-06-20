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
    dateFormatter.dateStyle = .long
    dateFormatter.locale = Locale.current
    dateFormatter.timeZone = TimeZone.current

    return dateFormatter.string(from: date)
  }
}
