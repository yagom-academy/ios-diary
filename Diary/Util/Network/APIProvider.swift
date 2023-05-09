//
//  Provider.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/09.
//

import Foundation

struct APIProvider {    
    func fetchData(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.responseError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.responseCodeError))
                return
            }
            
            guard let validData = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(validData))
           
        }
        
        dataTask.resume()
    }
}
