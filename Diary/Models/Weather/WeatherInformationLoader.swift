//
//  WeatherInformationLoader.swift
//  Diary
//
//  Created by Mangdi, junho lee, on 2023/01/04.
//

import Foundation

struct WeatherInformationLoader {
    func load(latitude: Double, longitude: Double, completion: @escaping (WeatherInformation?, ApiError?) -> Void) {
        guard let request = WeatherRequest.fetchWeatherInformation(latitude: latitude, longitude: longitude).request else {
            completion(nil, .wrongUrlError)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, .unknownError)
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completion(nil, .statusCodeError)
                return
            }
            guard let data = data,
                  let weatherInformation = try? JSONDecoder().decode(WeatherInformation.self, from: data) else {
                completion(nil, .jsonDecodingError)
                return
            }
            completion(weatherInformation, nil)
        }.resume()
    }
}
