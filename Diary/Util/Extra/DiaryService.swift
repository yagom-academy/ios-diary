//
//  DiaryService.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/09.
//

import Foundation
import CoreLocation

class DiaryService {
    private let provider = APIProvider()
    private let locationManager = CLLocationManager()
    private var endPoint = OpenWeatherEndpoint()
    
    private var latitude: Double = 0
    private var longitude: Double = 0
    
    private var weather: DailyWeather?
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        endPoint.updateQuery(lat: String(latitude), lon: String(longitude))
        
        guard let request = endPoint.makeURLRequest() else { return }
        
        provider.fetchData(request: request) { result in
            completion(result)
        }
    }
    
    func fetchWeatherIcon(iconId: String?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let id = iconId,
              let request = endPoint.makeURLRequest(iconId: id) else { return }
        
        provider.fetchData(request: request) { result in
            completion(result)
        }
    }
}
