//
//  SessionManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/23.
//

import Foundation

final class RequestManager {
    static let shared = RequestManager()
    private let sessionManager = URLSessionManager()
    
    private init() { }
    
    func requestAPI(lat: Double, lon: Double, completion: @escaping ((Result<Weather, Error>) -> Void)) {
        let endpoint: EndPoint = .weatherInfo(lat: lat, lon: lon)
        
        sessionManager.request(endpoint: endpoint) { data, response, error in
            guard let data = data else {
                return
            }
            
            // work
        }
    }
    
    func requestAPI(completion: @escaping ((Result<Weather, Error>) -> Void)) {
        let endpoint: EndPoint = .weatherIcon
        
        sessionManager.request(endpoint: endpoint) { data, response, error in
            guard let data = data else {
                return
            }
            
            // work
        }
    }
}
