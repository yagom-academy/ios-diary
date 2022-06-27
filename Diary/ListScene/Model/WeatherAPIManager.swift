//
//  WeatherAPIManager.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/27.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode(statusCode: Int?)
    case emptyData
    case responseError(error: Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalidURL"
        case .invalidStatusCode(let statusCode):
            return "statusCode: \(String(describing: statusCode))"
        case .emptyData:
            return "emptyData"
        case .responseError(let error):
            return "respondError: \(String(describing: error))"
        }
    }
}

final class WeatherAPIManager {
    
    func fetchData(url: URL, complition: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            if let error = error {
                return complition(.failure(.responseError(error: error)))
            }
            
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                complition(.failure(.invalidStatusCode(statusCode: (urlResponse as? HTTPURLResponse)?.statusCode)))
                return
            }
            
            guard let data = data else {
                return complition(.failure(.emptyData))
            }

            complition(.success(data))
        }
        
        task.resume()
        
        return task
    }
}
