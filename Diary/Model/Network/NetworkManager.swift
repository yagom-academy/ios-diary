//
//  NetworkManager.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation

final class NetworkManager {
    let urlSession = URLSession.shared
    var api: API?
    var decoder: DiaryDecodeManager
    
    init(api: API, decoder: DiaryDecodeManager = DiaryDecodeManager()) {
        self.api = api
        self.decoder = decoder
    }
    
    func fetch<T: Codable>(decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let api,
              let request = Endpoint.request(for: api) else { return }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.server))
                
                return
            }
            
            if let data = data,
               let decodedData = try? decoder.decode(decodingType, from: data) {
                completion(.success(decodedData))
                
                return
            }
            print(request)
            completion(.failure(NetworkError.decoding))
        }
        
        task.resume()
    }
}
