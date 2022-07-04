//
//  NetworkManager.swift
//  Diary
//
//  Created by 두기, marisol on 2022/07/01.
//

import Foundation

struct NetworkManager {
    func request(with apiAble: APIable, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let successRange = 200...299
        
        switch apiAble.method {
        case .get:
            guard let url = makeURL(apiAble) else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    completion(.failure(.error))
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    return
                }
                
                guard successRange.contains(statusCode) else {
                    completion(.failure(.statusCode))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.data))
                    return
                }
                
                completion(.success(data))
            }.resume()
        case .post:
            print(#function)
        case .patch:
            print(#function)
        case .delete:
            print(#function)
        }
    }
    
    private func makeURL(_ apiAble: APIable) -> URL? {
        var urlComponent = URLComponents(string: apiAble.url + apiAble.path)
        
        if let params = apiAble.params {
            urlComponent?.queryItems = params.compactMap {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        } else {
            guard let iconID = apiAble.iconID else {
                return nil
            }
            
            let iconParams = "\(iconID).png"
            
            urlComponent = URLComponents(string: apiAble.url + apiAble.path + iconParams)
        }
        
        guard let url = urlComponent?.url else {
            return nil
        }
        
        return url
    }
}
