//
//  NetworkManager.swift
//  Diary
//
//  Created by 김민성 on 2023/09/14.
//

import Foundation
import UIKit
import CoreLocation

final class NetworkManager {
    static let iconURL = "https://openweathermap.org/img/wn/"
    static let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
    
    static func fetchWeatherIcon(icon: String?) async throws -> Data {
        guard let icon = icon else {
            throw NetworkError.invalidIcon
        }
            
        let url = URL(string: iconURL + "\(icon)@2x.png")
        
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        guard (200..<300) ~= httpResponse.statusCode else {
            throw NetworkError.badStatusCode
        }
        
        return data
        
    }
    
    static func fetchCurrentWeather(coordinate: CLLocationCoordinate2D) async throws -> Weather? {
        var urlComponents = URLComponents(string: currentWeatherURL)
        let lat = URLQueryItem(name: "lat", value: coordinate.latitude.description)
        let lon = URLQueryItem(name: "lon", value: coordinate.longitude.description)
        let appid = URLQueryItem(name: "appid", value: "888d5726542be62a76b7fabed4352d4a")
        
        urlComponents?.queryItems = [lat, lon, appid]
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        guard (200..<300) ~= httpResponse.statusCode else {
            throw NetworkError.badStatusCode
        }
        
        return try WeatherDecoder.decode(jsonData: data)            
    }
}
