//
//  NetworkManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/28.
//

import Foundation

final class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    @discardableResult
    func request(
        endpoint: Requestable,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) -> URLSessionDataTask? {
        let urlRequest = endpoint.generateUrlRequest()
        
        switch urlRequest {
        case .success(let urlRequest):
            let task = session.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    completion(.failure(.responseError))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.responseError))
                    return
                }
                
                guard (200..<300).contains(response.statusCode) else {
                    completion(.failure(.invalidHttpStatusCodeError(statusCode: response.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.emptyDataError))
                    return
                }
                completion(.success(data))
            }
            task.resume()
            return task
        case .failure(let error):
            completion(.failure(error))
            return nil
        }
    }
}
