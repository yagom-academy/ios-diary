//
//  WeatherProvider.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/09.
//

import Foundation

struct WeatherProvider {
    func fetchData(_ target: WeatherAPI,
                   completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = target.createURLRequest() else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let result = self.checkError(with: data, response, error)
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func checkError(with data: Data?,
                    _ response: URLResponse?,
                    _ error: Error?
    ) -> Result<Data, Error> {
        if error != nil {
            return .failure(NetworkError.unknownError)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkError.unknownError)
        }
        
        guard (200...399).contains(httpResponse.statusCode) else {
            switch httpResponse.statusCode {
            case 400...499:
                return .failure(NetworkError.invalidRequestError)
            case 500...599:
                return .failure(NetworkError.invalidResponseError)
            default:
                return .failure(NetworkError.unknownError)
            }
        }
        
        guard let data = data else {
            return .failure(NetworkError.unknownError)
        }
        
        return .success(data)
    }
}
