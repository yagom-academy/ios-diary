//
//  WeatherIconLoader.swift
//  Diary
//
//  Created by junho lee on 2023/01/04.
//

import UIKit

struct WeatherIconLoader {
    private let imageURLCache = URLCache.shared

    func load(iconID: String, completion: @escaping (UIImage?, ApiError?) -> Void) {
        guard let request = WeatherRequest.fetchWeatherIcon(iconID: iconID).request else {
            completion(nil, ApiError.wrongUrlError)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error != nil else {
                completion(nil, .unknownError)
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completion(nil, .statusCodeError)
                return
            }
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil, .unknownError)
                return
            }
            let cachedUrlResponse = CachedURLResponse(response: response, data: data, storagePolicy: .allowed)
            imageURLCache.storeCachedResponse(cachedUrlResponse, for: request)
            completion(image, nil)
        }

        imageURLCache.getCachedResponse(for: dataTask) { response in
            guard let response = response,
                  let cachedImage = UIImage(data: response.data) else {
                dataTask.resume()
                return
            }
            completion(cachedImage, nil)
        }
    }
}
