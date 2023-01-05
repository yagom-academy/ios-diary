//
//  NetworkManager.swift
//  Diary
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

protocol NetworkService { }

protocol APINetworkService: NetworkService {
    func requestData<T: Decodable>(
        endPoint: Requesting,
        type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

extension APINetworkService {
    func requestData<T: Decodable>(
        endPoint: Requesting,
        type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let request = endPoint.convertURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.transportError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.translateResponseError))
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                completion(.failure(.serverError(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data,
                  let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.parsingError))
                return
            }
            
            completion(.success(decodeData))
        }
        
        task.resume()
    }
}

struct NetworkManager: APINetworkService { }
