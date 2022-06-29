//
//  NetworkService.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/28.
//

import Foundation

enum NetworkError: Error {
  case invalidateEndpoint
  case invalidateRequest
  case invalidateResponse
  case internalServerError
}

final class NetworkService {
  private let session: URLSession

  init(session: URLSession) {
    self.session = session
  }

  func request(endpoint: Requestable, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let urlRequest = endpoint.createRequest() else {
      completion(.failure(NetworkError.invalidateEndpoint))
      return
    }

    self.session.dataTask(with: urlRequest) { data, response, error in
      guard error == nil, let data = data else {
        completion(.failure(NetworkError.invalidateRequest))
        return
      }
      guard let response = response as? HTTPURLResponse else {
        completion(.failure(NetworkError.invalidateResponse))
        return
      }
      guard (200..<300).contains(response.statusCode) else {
        completion(.failure(NetworkError.internalServerError))
        return
      }
      completion(.success(data))
    }.resume()
  }
}
