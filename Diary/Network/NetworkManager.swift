//
//  NetworkManager.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/03.
//

import Foundation

enum NetworkError: LocalizedError {
    case responseError
    case invalidData
    case invalidURL
    case decodingError
    case unknownError

    var errorDescription: String {
        switch self {
        case .responseError:
            return "서버 응답이 없습니다."
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .decodingError:
            return "JSON 디코딩 실패 했습니다."
        case .unknownError:
            return "알 수 없는 에러입니다."
        }
    }
}

final class NetworkManager: Networkable {
    static let shared = NetworkManager()

    private init() {}

    func fetchData(url: URL?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.unknownError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.responseError))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}
