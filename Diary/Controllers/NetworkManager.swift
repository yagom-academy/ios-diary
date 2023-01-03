//
//  NetworkManager.swift
//  Diary
//
//  Created by Kyo, Baem on 2023/01/03.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(url: URL, completion: @escaping (Result<Weather, SessionError>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let sesseion = URLSession(configuration: .default)
        sesseion.dataTask(with: urlRequest) { data, response, error in
            guard error != nil else {
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
            
            do {
                let weatherData = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
}
