//
//  APIClient.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/29.
//

import Foundation

struct APIClient {
    private var session: URLSession
    static let shared = APIClient(session: URLSession.shared)
    
    private init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func requestData(with urlRequest: URLRequest,
                     completion: @escaping (Result<Data, APIError>) -> Void) {
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknownErrorOccured))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completion(.failure(.invalidURL))
                
                return
            }
            
            guard let verifiedData = data else {
                completion(.failure(.emptyData))
                
                return
            }
            
            completion(.success(verifiedData))
        }.resume()
    }
}
