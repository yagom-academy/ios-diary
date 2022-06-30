//
//  WeatherRepository.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/30.
//

import Foundation

final class WeatherRepository {
    private let networkManager = NetworkManager()
    private let jsonDecoder = JSONDecoder()
    
    func requestAPI (
        with endpoint: Requestable,
        completion: @escaping (Result<Weather?, NetworkError>) -> Void
    ) {
        networkManager.request(endpoint: endpoint) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let result):
                completion(.success(self.decode(data: result)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func decode(data: Data) -> Weather? {
        return try? jsonDecoder.decode(Weather.self, from: data)
    }
}
