//
//  APIManager.swift
//  Diary
//
//  Created by Hugh, Derrick kim on 2022/08/29.
//

import Foundation

struct APIManager: GETProtocol {
    var configuration: APIConfiguration

    init?(url: String, latitude: Double, longitude: Double) {
        guard var urlComponents = URLComponents(string: url) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: API.latitude, value: "\(latitude)"),
            URLQueryItem(name: API.longitude, value: "\(longitude)"),
            URLQueryItem(name: API.appID, value: API.key)]
        
        guard let url = urlComponents.url else {
            return nil
        }

        self.configuration = APIConfiguration(url: url)
    }
}
