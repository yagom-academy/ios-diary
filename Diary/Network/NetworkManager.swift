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

    private var apiKey: String {
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

    var weatherDataURL: URL? {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        let latitude = URLQueryItem(name: "lat", value: "\(self.coordinate.latitude)")
        let longitude = URLQueryItem(name: "lon", value: "\(self.coordinate.longitude)")
        let appID = URLQueryItem(name: "appid", value: "\(self.apiKey)")
        components?.queryItems = [latitude, longitude, appID]

        return components?.url
    }

    func weatherIconURL(icon: String) -> URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }

    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) {
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
            completion(.success(data))
        }
        dataTask.resume()
    }
}
