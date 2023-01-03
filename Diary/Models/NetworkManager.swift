//
//  NetworkManager.swift
//  Diary
//
//  Created by Mangdi on 2023/01/03.
//

import Foundation

struct NetworkManager {
    private let session = URLSession(configuration: .default)
    var imageTask: URLSessionDataTask?

    func createInformationUrl(latitude: Double, longitude: Double) -> String {
        let url = String(format: ApiUrl.informationUrl, latitude, longitude)
        return url
    }

    func createImageUrl(iconID: String) -> String {
        let url = String(format: ApiUrl.imageUrl, iconID)
        return url
    }

    func requestWeatherInfomation(url: String,
                                  completionHandler: @escaping (Result<WeatherInformation, ApiError>) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(.failure(.wrongUrlError))
            return
        }

        let task: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(.unknownError))
                return
            }

            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    completionHandler(.failure(.statusCodeError))
                    return
                }
            }

            if let data = data {
                do {
                    let decodingData = try JSONDecoder().decode(WeatherInformation.self, from: data)
                    completionHandler(.success(decodingData))
                } catch {
                    completionHandler(.failure(.jsonDecodingError))
                }
            }
        }
        task.resume()
    }

    mutating func requestImageData(url: URL,
                                   completionHandler: @escaping (Result<Data, ApiError>) -> Void) {
        imageTask = session.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil {
                completionHandler(.failure(.unknownError))
                return
            }

            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    completionHandler(.failure(.statusCodeError))
                    return
                }
            }

            if let data = data {
                completionHandler(.success(data))
            }
        })
        imageTask?.resume()
    }
}
