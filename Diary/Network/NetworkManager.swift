//
//  NetworkManager.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/03.
//

import Foundation

enum NetworkError: Error {
    case responseError
    case invalidData
    case invalidURL
    case decodingError
}

final class NetworkManager: Networkable {
    static let shared = NetworkManager()

    private init() {}

    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.responseError))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}
