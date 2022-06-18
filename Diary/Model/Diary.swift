//
//  Diary.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/15.
//

import Foundation

struct Diary: Decodable {
  let title: String
  let description: String
  let createdAt: TimeInterval
  
  enum CodingKeys: String, CodingKey {
    case title
    case description = "body"
    case createdAt = "created_at"
  }
}
