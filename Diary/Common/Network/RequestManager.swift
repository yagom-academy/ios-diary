//
//  SessionManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/23.
//

import UIKit
import CoreLocation

final class RequestManager {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func requestAPI(by coordinate: CLLocationCoordinate2D, completion: @escaping ((Result<Weather, Error>) -> Void)) {
        let endpoint: EndPoint = .weatherInfo(coordinate.latitude, coordinate.longitude)
        
        request(endpoint: endpoint) { result in
            switch result {
            case .success(let result):
                guard let decodedData = try? JSONDecoder().decode(Weather.self, from: result) else {
                    completion(.failure(DiaryError.networkError))
                    return
                }
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    func requestAPI(icon: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) -> URLSessionDataTask? {
        let endpoint: EndPoint = .weatherIcon(icon)
        
        return request(endpoint: endpoint) { result in
            switch result {
            case .success(let result):
                guard let image = UIImage(data: result) else {
                    completion(.failure(DiaryError.networkError))
                    return
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    private func request(
        endpoint: EndPoint,
        completion: @escaping ((Result<Data, Error>) -> Void)
    ) -> URLSessionDataTask? {
        guard let url = endpoint.url else {
            return nil
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(DiaryError.networkError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode)
            else {
                completion(.failure(DiaryError.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(DiaryError.networkError))
                return
            }
            completion(.success(data))
        }
        task.resume()
        
        return task
    }
}
