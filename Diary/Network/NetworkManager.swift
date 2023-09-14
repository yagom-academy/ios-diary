//
//  NetworkManager.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/14.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: URLalbe>(API: T, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let APIUrl = API.url,
              let url = URL(string: APIUrl) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.failureRequest))
                return
            }

            guard let response = response,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.failureResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidDataType))
                return
            }

            completion(.success(data))
        }
        
        task.resume()
    }
}
