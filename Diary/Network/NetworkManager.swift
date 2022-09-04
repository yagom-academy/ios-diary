//
//  NetworkManager.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/31.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    func requestWeatherData(latitude: String?, longitude: String?, _ completion: @escaping (WeatherModel) -> Void) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        guard var urlComponents = URLComponents(string: URLData.host) else {
            return
        }
        urlComponents.queryItems = [
            .init(name: "lat", value: latitude),
            .init(name: "lon", value: longitude),
            .init(name: "appId", value: URLData.apiKey)
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
    
    func requestWeatherImage(iconId: String, iconImage: UIImageView) {
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(iconId)@2x.png") else { return }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            let successRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                iconImage.image = image
            }
        }
        dataTask.resume()
    }
}
