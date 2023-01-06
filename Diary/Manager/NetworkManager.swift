//
//  HTTPManager.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2023/01/04.
//

import Foundation

final class NetworkManager {
    func requestGet(url: URL?, completion: @escaping (Result<NSData, NetworkError>) -> Void) {
        guard let validURL = url else {
            completion(.failure(.clientError))
            return
        }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = "GET"
        
        requestToServer(with: urlRequest, completion: completion)
    }
    
    private func requestToServer(with urlRequest: URLRequest,
                                 completion: @escaping (Result<NSData, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data = data else {
                completion(.failure(.clientError))
                return
            }
            
            guard let response = urlResponse as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                if let response = urlResponse as? HTTPURLResponse {
                    print(response.description)
                    completion(.failure(.clientError))
                }
                return
            }
            
            guard error == nil else {
                completion(.failure(.serverError))
                return
            }
            
            completion(.success(data as NSData))
        }.resume()
    }
}
