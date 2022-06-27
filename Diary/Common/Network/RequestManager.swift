//
//  SessionManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/23.
//

import UIKit
import CoreLocation

final class RequestManager {
    static let shared = RequestManager()
    
    private init() { }
    
    func requestAPI(by coordinate: CLLocationCoordinate2D, completion: @escaping ((Result<Weather, Error>) -> Void)) {
        let endpoint: EndPoint = .weatherInfo(coordinate.latitude, coordinate.longitude)
        
        request(endpoint: endpoint) { [weak self] data, response, error in
            self?.verifyError(with: data, response, error) { result in
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
    }
    
    func requestAPI(icon: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        let endpoint: EndPoint = .weatherIcon(icon)
        
        request(endpoint: endpoint) { [weak self] data, response, error in
            self?.verifyError(with: data, response, error) { result in
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
    }
    
    private func request(endpoint: EndPoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = endpoint.url else {
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
    private func verifyError(
        with data: Data?,
        _ response: URLResponse?,
        _ error: Error?,
        completion: @escaping ((Result<Data, Error>) -> Void)
    ) {
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
}
