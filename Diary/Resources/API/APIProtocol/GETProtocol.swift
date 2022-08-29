//
//  GETProtocol.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/29.
//

import UIKit

protocol GETProtocol: APIProtocol { }

extension GETProtocol {
    func requestAndDecodeWeather<T: Decodable>(using client: APIClient = APIClient.shared,
                                               dataType: T.Type,
                                               completion: @escaping (Result<T, APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        request.httpMethod = HTTPMethod.get
        
        client.requestData(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self,
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
    
    func requestImage(using client: APIClient = APIClient.shared,
                      id: UUID,
                      completion: @escaping (Result<UIImage, APIError>) -> Void) {
        let iconImageCache = NSCache<NSString, UIImage>()
        let id = NSString(string: id.uuidString)
        
        if let cachedImage = iconImageCache.object(forKey: id) {
            completion(.success(cachedImage))
            
            return
        }
        
        var request = URLRequest(url: configuration.url)
        request.httpMethod = HTTPMethod.get
        
        client.requestData(with: request) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(.failedToConvert))
                    return
                }
                iconImageCache.setObject(image, forKey: id)
                completion(.success(image))
            case .failure(_):
                completion(.failure(.emptyData))
            }
        }
    }
}
