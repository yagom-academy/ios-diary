//
//  NetworkManager.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/03.
//

import Foundation
import CoreLocation

enum NetworkError: Error {
    case responseError
    case invalidData
    case invalidURL
    case decodingError
}

class NetworkManager {
    private var apikey: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("plist를 찾을 수 없습니다.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "Open Weather API KEY") as? String else {
            fatalError("Open Weather API KEY를 찾을 수 없습니다.")
        }

        return value
    }

    private var coordinate: CLLocationCoordinate2D {
        guard let coordinate = CLLocationManager.init().location?.coordinate else {
            fatalError("위치를 찾을 수 없습니다.")
        }

        return coordinate
    }

    lazy var url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(self.coordinate.latitude)&lon=\(self.coordinate.longitude)&appid=\(self.apikey)")

    func fetchWeather(completion: @escaping (Result<WeatherResponseDTO, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completion(.failure(NetworkError.responseError))
                      return
                  }
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }

            guard let weatherResponseDTO = try? JSONDecoder().decode(WeatherResponseDTO.self, from: data) else {
                completion(.failure(NetworkError.decodingError))
                return
            }
            completion(.success(weatherResponseDTO))
        }
        dataTask.resume()
    }
}
