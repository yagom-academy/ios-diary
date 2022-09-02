//
//  NetworkManager.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/09/02.
//

import Foundation

struct NetworkManager: SessionProtocol {
    func dataTask(with request: APIRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let request = request.urlRequest else {
            completionHandler(.failure(APIError.request))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(.failure(APIError.request))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 <= response.statusCode, response.statusCode < 300
            else {
                completionHandler(.failure(APIError.response))
                return
            }
            
            guard let safeData = data else {
                completionHandler(.failure(APIError.invalidData))
                return
            }
            
            completionHandler(.success(safeData))
        }
        task.resume()
    }
}
