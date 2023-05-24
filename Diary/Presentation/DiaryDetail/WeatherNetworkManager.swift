//
//  WeatherDataManager.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/11.
//

import Foundation

final class WeatherNetworkManager {
    private let networkManager = NetworkManager()
    
    func fetchInfo(coordinate: Coordinate, completion: @escaping (Result<(Data, Weather), Error>) -> Void) {
        let endPoint = EndPoint.weatherInfo(latitude: coordinate.latitude,
                                            longitude: coordinate.longitude).asURLRequest()

        NetworkManager().fetchData(urlRequest: endPoint) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let data):
                self.decode(data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func decode(_ data: Data, completion: @escaping (Result<(Data, Weather), Error>) -> Void) {
        let result = DecodeManager().decodeAPI(data: data, type: WeatherData.self)

        switch result {
        case .success(let weatherData):
            guard let weatherIconCode = weatherData.weather.first?.iconCode,
                  let weatherType = weatherData.weather.first?.type else {
                completion(.failure(NetworkError.dataNotFound))

                return
            }

            let weather = Weather(type: weatherType, iconCode: weatherIconCode)
            
            fetchImage(weather: weather, completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func fetchImage(weather: Weather, completion: @escaping (Result<(Data, Weather), Error>) -> Void) {
        let endPoint = EndPoint.weatherImage(iconCode: weather.iconCode).asURLRequest()

        NetworkManager().fetchData(urlRequest: endPoint) { result in
            switch result {
            case .success(let image):
                completion(.success((image, weather)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
