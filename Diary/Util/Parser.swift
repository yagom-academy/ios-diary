//
//  Parser.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/17.
//

import UIKit

enum Parser {
  private static let jsonDecoder = JSONDecoder()

  static func decode<T: Decodable>(type: T.Type, assetName: String) -> T? {
    self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

    guard let dataAsset = NSDataAsset(name: assetName) else { return nil }
    guard let result = try? self.jsonDecoder.decode(type, from: dataAsset.data) else { return nil }

    return result
  }
}
