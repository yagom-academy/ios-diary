//
//  DefaultWeatherService.swift
//  Diary
//
//  Created by WeatherService on 2023/05/10.
//

import Foundation

final class DefaultWeatherService: WeatherService {
    let networkProvider: NetworkProvider = DefaultNetworkProvider()
}
