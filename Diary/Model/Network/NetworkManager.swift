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
    
    static func fetchWeatherIcon(icon: String) async -> UIImage? {
        let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return nil
            }
            
            guard (200..<300) ~= httpResponse.statusCode else {
                return nil
            }
            
            return UIImage(data: data)
            
        } catch {
            return nil
        }
    }
    
    static func fetchCurrentWeather(coordinate: CLLocationCoordinate2D) async -> Weather? {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=888d5726542be62a76b7fabed4352d4a"
        do {
            let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return nil
            }
            
            guard (200..<300) ~= httpResponse.statusCode else {
                return nil
            }
            
            return WeatherDecoder.decode(jsonData: data)
            
        } catch {
            return nil
        }
        
    }
}
