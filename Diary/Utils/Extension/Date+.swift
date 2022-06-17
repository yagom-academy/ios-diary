//
//  Date+.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/16.
//

import Foundation

extension Date {
  func setKoreaDateFormat(dateFormat: DateFormat) -> String {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = dateFormat.form
    dateformatter.locale = Locale(identifier: "ko_KR")
    let date = dateformatter.string(from: self)
    return date
  }
}
