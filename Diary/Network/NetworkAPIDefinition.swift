//
//  NetworkAPIDefinition.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/14.
//

import Foundation

protocol NetworkAPIDefinition {
    typealias URLInfo = NetworkAPI.URLInfo
    
    var urlInfo: URLInfo { get }
}

extension NetworkAPIDefinition {
    func request(completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let url = urlInfo.url else {
            return
        }
        
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let dataTask = session.dataTask(with: request) { data, response, error in
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
        
        dataTask.resume()
    }
}
