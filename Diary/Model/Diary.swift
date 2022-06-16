//
//  Diary.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/15.
//

import Foundation

struct Diary: Decodable {
  let title: String
  let body: String
  let createdAt: TimeInterval
}
