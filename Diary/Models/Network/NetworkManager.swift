//
//  NetworkManager.swift
//  Diary
//
//  Created by Kyo, Baem on 2023/01/03.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(url: URL?, completion: @escaping (Result<Data, SessionError>) -> Void) {
        guard let url = url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let sesseion = URLSession(configuration: .default)
        
        sesseion.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.networkError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noneDataError))
                return
            }
            
            completion(.success(data))

        }.resume()
    }
}
