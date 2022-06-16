//
//  DiaryData.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/16.
//

import Foundation

struct PassorManager {
  static func fetchJsonData() -> [Diary]? {
    guard let path = Bundle.main.path(forResource: "sample", ofType: "json") else {
      return nil
    }
    
    guard let jsonData = try? String(contentsOfFile: path).data(using: .utf8) else {
      return nil
    }

    let diaryData = try? Json.decoder.decode([Diary].self, from: jsonData)
    
    return diaryData
  }
}
