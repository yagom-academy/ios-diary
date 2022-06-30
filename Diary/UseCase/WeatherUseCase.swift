//
//  WeatherUseCase.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/07/01.
//

final class WeatherUseCase {
    private let repository = WeatherRepository()
    
    func requestWeather(
        latitude: Double?,
        longitude: Double?,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        guard let latitude = latitude,
              let longitude = longitude
        else {
            completion(.failure(.emptyDataError))
            return
        }
        
        let endpoint = EndpointStorage
            .weatherInfo(latitude, longitude)
            .endPoint
        
        repository.requestAPI(with: endpoint) { (result: Result<Weather?, NetworkError>) in
            switch result {
            case .success(let result):
                guard let icon = result?.weather.first?.icon else {
                    completion(.failure(.emptyDataError))
                    return
                }
                completion(.success(icon))
            case .failure:
                completion(.failure(.emptyDataError))
            }
        }
    }
}
