//
//  NetworkManager.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation
import UIKit

final class NetworkManager {
    let urlSession = URLSession.shared
    var jsonDecoder: JSONDecoder = JSONDecoder()
    
    func fetch<T: Decodable>(
        request: URLRequest?,
        decodingType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let request else {
            completion(.failure(NetworkError.urlError))
            
            return
        }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponseError))
                
                return
            }
                    
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidHttpStatusCode(httpResponse.statusCode)))
                
                return
            }
            
            guard let data = data,
                  let decodedData = try? self.jsonDecoder.decode(decodingType, from: data) else {
                completion(.failure(NetworkError.decodeError))
                
                return
            }
            
            completion(.success(decodedData))
        }
        
        task.resume()
    }
    
    func fetchImage(request: URLRequest?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let request else {
            completion(.failure(NetworkError.urlError))
            
            return
        }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponseError))
                
                return
            }
                    
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidHttpStatusCode(httpResponse.statusCode)))
                
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(.failure(NetworkError.emptyData))
                
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
    }
}
