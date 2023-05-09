//
//  DiaryService.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/09.
//

import Foundation

class DiaryService {
    private let provider = APIProvider()
    private var endPoint = OpenWeatherEndpoint()
    
    private var latitude: Double = 0
    private var longitude: Double = 0
    
    private var weather: Weather?
    
    func fetchWeather(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        endPoint.updateCoordinate(lat: String(latitude), lon: String(longitude))
        
        guard let request = endPoint.makeURLRequest() else { return }
        
        provider.fetchData(request: request) { result in
            completion(result)
        }
    }
}
