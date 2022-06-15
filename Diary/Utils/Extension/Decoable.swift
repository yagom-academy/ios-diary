//
//  Decoable.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/15.
//

import Foundation

extension Decodable {
  static func parse(data: Data) -> Self? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    guard let diary = try? decoder.decode(Self.self, from: data) else {
      return nil
    }
    
    return diary
  }
}
