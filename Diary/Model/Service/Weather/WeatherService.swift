//
//  WeatherService.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/10.
//

import Foundation

protocol WeatherService {
    var networkProvider: NetworkProvider { get }

    func fetchWeatherInformation(
        latitude: Double,
        longtitude: Double,
        completion: @escaping ((Result<WeatherInformation, NetworkError>) -> Void)
    )
}

extension WeatherService {
    func fetchWeatherInformation(
        latitude: Double,
        longtitude: Double,
        completion: @escaping ((Result<WeatherInformation, NetworkError>) -> Void)
    ) {
        let endPoint = WeatherInformationEndpoint(
            latitude: String(latitude),
            longtitude: String(longtitude)
        )
        return self.networkProvider.request(endPoint) { result in
            completion(result.map { $0.convertToWeatherItems() })
        }
    }
}
