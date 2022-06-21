//
//  Diary.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/15.
//

import Foundation

struct Diary: Decodable {
  let title: String
  let content: String
  let createdAt: Date
  let identifier: String

  
  enum CodingKeys: String, CodingKey {
    case title, identifier
    case content = "body"
    case createdAt = "created_at"
  }
}
