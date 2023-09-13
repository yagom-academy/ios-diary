//
//  NetworkManager.swift
//  Diary
//
//  Created by Max, Hemg on 2023/09/13.
//

import CoreLocation

final class NetworkManager {
    static let shared = NetworkManager()
    private var dataTask: URLSessionDataTask?
    
    private init() {}
    
    func fetchData(_ networkType: NetworkConfiguration, completionHandler: @escaping(Result<Data, APIError>) -> Void) {
        guard let urlString = networkType.url,
              let url = URL(string: urlString) else {
            completionHandler(.failure(APIError.invalidURL))
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(.requestFail))
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299) ~= httpResponse.statusCode else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            guard let data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
        self.dataTask?.resume()
    }
}
