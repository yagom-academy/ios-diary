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
            URLQueryItem(name: WeatherAPIConst.latitude, value: "\(latitude)"),
            URLQueryItem(name: WeatherAPIConst.longitude, value: "\(longitude)"),
            URLQueryItem(name: WeatherAPIConst.appID, value: WeatherAPIConst.key)]
        
        guard let url = urlComponents.url else {
            return nil
        }

        self.configuration = APIConfiguration(url: url)
    }
}
