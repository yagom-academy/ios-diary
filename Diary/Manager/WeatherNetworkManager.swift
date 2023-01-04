//
//  WeatherNetworkManager.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/01/04.
//

import Foundation

final class WeatherNetworkManager: NetworkManageable {
    static let shared = WeatherNetworkManager()
    
    private init() {}
    
    func getJSONData<T: Codable>(url: String, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        NetworkManager.shared.requestGet(url: url) { result in
            switch result {
            case .success(let data):
                guard let data: T = JSONConverter.shared.decodeData(data: data as Data) else {
                    completion(.failure(.missingData))
                    return
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    func getImageData(url: String, completion: @escaping (Result<NSData, NetworkError>) -> Void) {
        let cachedKey = NSString(string: "\(url)")
        
        if let cachedData = ImageDataCacheManager.shared.object(forKey: cachedKey) {
            return completion(.success(cachedData))
        }
        
        NetworkManager.shared.requestGet(url: url) { result in
            switch result {
            case .success(let data):
                ImageDataCacheManager.shared.setObject(data,
                                                       forKey: cachedKey)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

protocol NetworkManageable {
    func getJSONData<T: Codable>(url: String, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
    func getImageData(url: String, completion: @escaping (Result<NSData, NetworkError>) -> Void)
}
