//
//  OpenWeatherService.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import UIKit

final class OpenWeatherService {
    private let networkManager = NetworkManager()
    
    func loadData(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        let api = OpenWeatherAPI.currentData(latitude: latitude, longitude: longitude)
        let request = Endpoint.request(for: api)
        
        networkManager.fetch(request: request,
                             decodingType: CurrentWeather.self,
                             completion: completion)
    }
    
    func loadIcon(code: String?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let code else { return }
        
        let api = OpenWeatherAPI.icon(code: code)
        let request = Endpoint.request(for: api)
        
        networkManager.fetchImage(request: request,
                                  completion: completion)
    }
}
