//
//  Endpoint.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/29.
//

import Foundation

enum HTTPMethod: String {
  case get = "GET"
}

protocol Requestable {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var queries: [String: String] { get }
  var headers: [String: String] { get }
  var payload: Data? { get }
}
