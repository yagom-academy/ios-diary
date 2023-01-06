//
//  WeatherNetworkManager.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2023/01/04.
//

import Foundation

final class WeatherNetworkManager: NetworkManageable {
    private let networkManager = NetworkManager()
    
    func getJSONData<T: Decodable>(url: URL?, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        networkManager.requestGet(url: url) { result in
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
}

protocol NetworkManageable {
    func getJSONData<T: Decodable>(url: URL?, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}
