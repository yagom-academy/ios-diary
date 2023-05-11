//
//  WeatherDataManager.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/11.
//

import Foundation

final class WeatherDataManager {
    private let networkManager = NetworkManager()
    
    func fetchWeatherInfo(coordinate: Coordinate, completion: @escaping (Result<Data, Error>) -> Void) {
        let endPoint = EndPoint.weatherInfo(latitude: coordinate.latitude,
                                            longitude: coordinate.longitude).asURLRequest()

        NetworkManager().fetchData(urlRequest: endPoint) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let data):
                self.decode(data, completion: completion)
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private func decode(_ data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        let result = DecodeManager().decodeAPI(data: data, type: WeatherDTO.self)

        switch result {
        case .success(let weatherDTO):
            guard let weatherIconCode = weatherDTO.weather.first?.iconCode,
                  let weatherType = weatherDTO.weather.first?.type else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.dataNotFound))
                }

                return
            }

            let weather = Weather(type: weatherType, iconCode: weatherIconCode)
            
            fetchWeatherImage(weather: weather, completion: completion)
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }

    private func fetchWeatherImage(weather: Weather, completion: @escaping (Result<Data, Error>) -> Void) {
        let endPoint = EndPoint.weatherImage(iconCode: weather.iconCode).asURLRequest()

        NetworkManager().fetchData(urlRequest: endPoint) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
