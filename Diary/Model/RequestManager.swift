//
//  SessionManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/23.
//

import Foundation
import UIKit

final class RequestManager {
    static let shared = RequestManager()
    private let sessionManager = URLSessionManager()
    
    private init() { }
    
    func requestAPI(lat: Double, lon: Double, completion: @escaping ((Result<Weather, Error>) -> Void)) {
        let endpoint: EndPoint = .weatherInfo(lat: lat, lon: lon)
        
        sessionManager.request(endpoint: endpoint) { data, response, error in
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
            
            guard let decodedData = try? JSONDecoder().decode(Weather.self, from: data) else {
                completion(.failure(DiaryError.networkError))
                return
            }
            completion(.success(decodedData))
        }
    }
    
    func requestAPI(icon: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        let endpoint: EndPoint = .weatherIcon(icon: icon)
        
        sessionManager.request(endpoint: endpoint) { data, response, error in
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
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            completion(.success(image))
        }
    }
}
