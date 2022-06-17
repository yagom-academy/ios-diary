//
//  DateFormat.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/17.
//

import Foundation

enum DateFormat {
  case yearMonthDay
  case yearMonth
  case monthDay
  
  var form: String {
    switch self {
    case .yearMonthDay:
      return "yyyy년 MM월 dd일"
    case .yearMonth:
      return "yyyy년 MM월"
    case .monthDay:
      return "MM월 dd일"
    }
  }
}
