//
//  TimeInterval+.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/16.
//

import Foundation

extension TimeInterval {
  func setKoreaDateFormat() -> String {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy년 MM월 dd일"
    dateformatter.locale = Locale(identifier: "ko_KR")
    let date = dateformatter.string(from: Date(timeIntervalSince1970: self))
    return date
  }
}
