//
//  Decoable.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/15.
//

import Foundation

struct Json {
  static let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
  
  private init() {}
}
