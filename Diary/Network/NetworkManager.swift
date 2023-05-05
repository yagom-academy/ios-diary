//
//  NetworkManager.swift
//  Diary
//
//  Created by 리지, Goat on 2023/05/05.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func startLoad<Element: Decodable>(endPoint: WeatherEndpoint, returnType: Element.Type, completion: @escaping (Result<Element, DiaryError>) -> Void) {
        guard let urlRequest = endPoint.createURLRequestForGET() else { return }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(.networkUnknown))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.networkResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.networkStatusCode))
                return
            }
            
            if let data = data {
                do {
                    guard let jsonData = try Decoder.parseJSON(data: data, returnType: returnType) else {
                        completion(.failure(.decodeFailure))
                        return
                    }
                    completion(.success(jsonData))
                } catch {
                    completion(.failure(.decodeFailure))
                }
            }
        }
        task.resume()
    }
}
