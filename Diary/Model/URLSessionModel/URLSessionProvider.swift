//
//  URLSessionProvider.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/03.
//

import Foundation

struct URLSessionProvider {
    let session = URLSession.shared
    
    func fetchData(url: URL,
                   completion: @escaping (Result<Data, NetworkError>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFailError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode)  else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                completion(.failure(.httpResponseError(code: statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noDataError))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}

enum NetworkError: Error {
    case requestFailError
    case httpResponseError(code: Int)
    case noDataError
    case generateUrlFailError
}
