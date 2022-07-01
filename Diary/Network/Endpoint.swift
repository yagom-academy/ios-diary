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

final class Endpoint {
  let baseURL: String
  let path: String
  let method: HTTPMethod
  let queries: [String: String]
  let headers: [String: String]
  let payload: Data?

  init(
    baseURL: String,
    path: String,
    method: HTTPMethod = .get,
    queries: [String: String] = [:],
    headers: [String: String] = [:],
    payload: Data? = nil
  ) {
    self.baseURL = baseURL
    self.path = path
    self.method = method
    self.queries = queries
    self.headers = headers
    self.payload = payload
  }

  private func createURL() -> URL? {
    var urlString = self.baseURL

    if urlString.hasSuffix("/") == false {
      urlString.append("/")
    }

    urlString.append(self.path)

    var component = URLComponents(string: urlString)

    if self.method == .get {
      component?.queryItems = self.queries.map {
        URLQueryItem(name: $0.key, value: $0.value)
      }
    }

    return component?.url
  }

  func createRequest() -> URLRequest? {
    guard let url = self.createURL() else { return nil }

    var request = URLRequest(url: url)

    self.headers.forEach {
      request.addValue($0.value, forHTTPHeaderField: $0.key)
    }

    if let payload = payload {
      request.httpBody = payload
    }

    return request
  }
}
