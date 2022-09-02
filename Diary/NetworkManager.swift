//
//  NetworkManager.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/31.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    func requestWeatherData(latitude: String?, longitude: String?, _ completion: @escaping (WeatherModel) -> Void) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        guard var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather") else {
            return
        }
        urlComponents.queryItems = [
            .init(name: "lat", value: latitude),
            .init(name: "lon", value: longitude),
            .init(name: "appId", value: "82dc71828b844e5d194f3128d649c0e8")
        ]
        guard let url = urlComponents.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            let successRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            guard let data = data,
                  let fetchedData = JsonParser.fetch(data) else {
                return
            }
            completion(fetchedData)
        }
        dataTask.resume()
    }
}
