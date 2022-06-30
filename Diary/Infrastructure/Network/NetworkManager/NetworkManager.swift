//
//  NetworkManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/28.
//

import Foundation

final class WeatherRepository {
    private let networkManager = NetworkManager()
    private let jsonDecoder = JSONDecoder()
    
    func requestAPI (
        with endpoint: Requestable,
        completion: @escaping (Result<Weather?, Error>) -> Void
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
//        do {
//            let decoded = try jsonDecoder.decode(Weather.self, from: data)
//            return decoded
//        } catch {
//            return .failure(NetworkError.decodeError)
//        }
    }
}

final class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    
    
    @discardableResult
    func request(
        endpoint: Requestable,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask? {
        let urlRequest = endpoint.generateUrlRequest()
        
        switch urlRequest {
        case .success(let urlRequest):
            let task = session.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    completion(.failure(NetworkError.responseError))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.responseError))
                    return
                }
                
                guard (200..<300).contains(response.statusCode) else {
                    completion(.failure(NetworkError.invalidHttpStatusCodeError(statusCode: response.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.emptyDataError))
                    return
                }
                completion(.success(data))
            }
            task.resume()
            return task
        case .failure(let error):
            completion(.failure(error))
            return nil
        }
    }
}

fileprivate extension Data {
    func decode<T: Decodable>(with decoder: JSONDecoder) -> Result<T, Error> {
        do {
            let decoded = try decoder.decode(T.self, from: self)
            return .success(decoded)
        } catch {
            return .failure(NetworkError.decodeError)
        }
    }
}
