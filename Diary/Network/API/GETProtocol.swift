//
//  GETProtocol.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/29.
//

import Foundation

protocol GETProtocol {
    var configuration: APIConfiguration { get }
}

extension GETProtocol {
    func requestAndDecode<T: Decodable>(using client: APIClient = APIClient.shared,
                                        dataType: T.Type,
                                        completion: @escaping (Result<T,APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        request.httpMethod = "GET"
        
        client.requestData(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let decodedData = try decoder.decode(T.self,
                                                         from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.failedToDecode))
                }
            case .failure(_):
                completion(.failure(.emptyData))
            }
        }
    }
}
