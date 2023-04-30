//
//  DateFormatter.swift
//  Diary
//
// Created by SeHong on 2023/04/24.
//

import Foundation

enum DateToStringFormatter {
    
  private static let dateFormatter = DateFormatter()

  static func changeToString(from timeInterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeInterval)
    dateFormatter.dateStyle = .long
    dateFormatter.locale = Locale.current
    dateFormatter.timeZone = TimeZone.current
      
    return dateFormatter.string(from: date)
  }
    
}
