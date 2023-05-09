//
//  OpenWetherDataLoader.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation

class OpenWetherDataLoader {
    private let networkManager = NetworkManager()
    
    func loadData(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        let api = OpenWeatherAPI.currentData(latitude: latitude, longitude: longitude)
        let request = Endpoint.request(for: api)
        
        networkManager.fetch(request: request,
                             decodingType: CurrentWeather.self,
                             completion: completion)
    }
}
