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
        
    }
    
    func getImageData(url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
    }
}

protocol NetworkManageable {
    func getJSONData<T: Codable>(url: String, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
    func getImageData(url: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
