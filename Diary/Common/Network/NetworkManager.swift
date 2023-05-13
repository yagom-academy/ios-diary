//
//  NetworkManager.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/08.
//

import Foundation

struct NetworkManager {
    func fetchData(urlRequest: URLRequest?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let urlRequest else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(NetworkError.transportFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(checkStatus(code: httpResponse.statusCode)))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.dataNotFound))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    private func checkStatus(code: Int) -> NetworkError {
        switch code {
        case 400...499:
            return .clientError(code)
        case 500...599:
            return .serverError(code)
        default:
            return .unknown(code)
        }
    }
}
