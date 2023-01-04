//
//  NetworkManager.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/03.
//

import UIKit
import CoreLocation

enum NetworkError: Error {
    case responseError
    case invalidData
    case invalidURL
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()

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
        guard let coordinate = CLLocationManager().location?.coordinate else {
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

    func fetchWeatherIconImage(icon: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else {
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

            guard let data = data,
                  let weatherIconImage = UIImage(data: data) else {
                completion(.failure(NetworkError.invalidData))
                return
            }

            completion(.success(weatherIconImage))
        }
        dataTask.resume()
    }
}
