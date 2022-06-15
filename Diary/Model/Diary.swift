//
//  Diary.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/14.
//

import UIKit

struct Diary: Decodable {
  let title: String
  let body: String
  let createdAt: Double

  var createdAtString: String {
    let date = Date(timeIntervalSince1970: createdAt)
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.locale = Locale.current
    dateFormatter.timeZone = TimeZone.current

    return dateFormatter.string(from: date)
  }
}

extension Diary {
  static let decodedData: [Diary] = {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

    guard let dataAsset = NSDataAsset(name: "sample"),
          let diaries = try? jsonDecoder.decode([Diary].self, from: dataAsset.data)
    else { return [] }

    return diaries
  }()
}
