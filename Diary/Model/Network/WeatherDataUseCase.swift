//
//  WeatherDataUseCase.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/06/03.
//

import Foundation

struct WeatherDataUseCase {
    private let network: NetworkAble
    private let jsonDecoder: JSONDecoder

    init(network: Network, jsonDecoder: JSONDecoder) {
        self.network = network
        self.jsonDecoder = jsonDecoder
    }
    
    func requestWeatherData(
        location: Location,
        completeHandler: @escaping (WeatherData) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) {
        guard let url = WeatherApi.weatherData(lat: location.lat, lon: location.lon).url else {
            errorHandler(NetworkError.urlError)
            return
        }
        
        network.requestData(url) { data, _ in
            guard let decodedData = try? jsonDecoder.decode(WeatherData.self, from: data) else {
                errorHandler(NetworkError.dataError)
                return
            }
            completeHandler(decodedData)
        } errorHandler: { error in
            errorHandler(error)
        }
    }
}
