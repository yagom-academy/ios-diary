//
//  Diary.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/14.
//

import UIKit

struct Diary: Decodable {
  let uuid: String?
  var title: String?
  var body: String?
  let createdAtTimeFrom1970: Double
  let weatherIconID: String?

  private enum CodingKeys: String, CodingKey {
    case uuid
    case title
    case body
    case createdAtTimeFrom1970
    case weatherIconID
  }
}
