//
//  Diary - NetworkManager.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import Foundation
final class NetworkManager {
    static let shared = NetworkManager()
    private let urlSession = URLSession(configuration: .default)
    
    func startLoad(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        urlSession.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.responseError))
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.responseCodeError))
                
                return
            }
            
            guard let validData = data else {
                completion(.failure(NetworkError.dataError))
                
                return
            }
            
            completion(.success(validData))
        }.resume()
    }
}
