//
//  NetworkProvider.swift
//  Diary
//
//  Created by Andrew on 2023/05/10.
//

import Foundation

protocol NetworkProvider {
    var session: URLSession { get }
    func request<T: APIEndpoint>(
        request: T,
        completion: @escaping (Result<T.APIResponse, NetworkError>) -> Void )
}

extension NetworkProvider {
    func request<T: APIEndpoint>(
        _ request: T,
        completion: @escaping (Result<T.APIResponse, NetworkError>) -> Void
    ) {
        guard let urlRequest = request.urlRequest else {
            completion(.failure(.invalidRequest))
            return
        }
        
        let task = self.session.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(.unknownError))
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidStatusCode(code: response.statusCode, data: data)))
                return
            }
            
            do {
                let decoded: T.APIResponse = try request.decoder.decode(data: data)
                completion(.success(decoded))
            } catch let error {
                let decodingError = error as? DecodingError
                completion(.failure(.parsingFailure(decodingError: decodingError, data: data)))
            }
        }
        task.resume()
    }
}
