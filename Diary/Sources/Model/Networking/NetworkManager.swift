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
        completion: @escaping (T) -> Void
    )
}

extension APINetworkService {
    func requestData<T: Decodable>(
        endPoint: Requesting,
        type: T.Type,
        completion: @escaping (T) -> Void
    ) {
        guard let request = endPoint.convertURL() else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299) ~= response.statusCode else {
                return
            }
            
            guard let data = data,
                  let decodeData = try? JSONDecoder().decode(T.self, from: data) else { return }
            
            completion(decodeData)
        }
        
        task.resume()
    }
}

struct NetworkManager: APINetworkService { }
