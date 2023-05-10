//
//  NetworkManager.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/10.
//

import Foundation

struct NetworkManager {
    private let session: URLSession = .shared
    
    func fetchData<T: Decodable>(request: URLRequest?, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = request else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            self.checkError(with: data, response, error) { result in
                switch result {
                case .success(let data):
                    completion(self.decode(data: data, type: type))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    private func checkError(with data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping (Result<Data, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.invalidResponseError))
            return
        }
        
        guard (200...299).contains(response.statusCode) else {
            completion(.failure(NetworkError.invalidHttpStatusCode(response.statusCode)))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.emptyData))
            return
        }
        
        completion(.success(data))
    }
    
    private func decode<T: Decodable>(data: Data, type: T.Type) -> Result<T, Error> {
        do {
            let decodedData = try JSONDecoder().decode(type, from: data)
            return .success(decodedData)
        } catch {
            return .failure(NetworkError.decodeError)
        }
    }
}
