//
//  DiaryService.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/09.
//

import Foundation
import CoreLocation

final class DiaryService: NSObject {
    private let provider = APIProvider()
    private let locationManager = CLLocationManager()
    private var endPoint = OpenWeatherEndpoint()
    
    private var latitude: Double = 0
    private var longitude: Double = 0
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func fetchWeatherIcon(completion: @escaping (Data?) -> Void) {
        endPoint.updateQuery(lat: String(latitude), lon: String(longitude))
        
        guard let request = endPoint.makeURLRequest() else { return }
        
        provider.fetchData(request: request) { [weak self] result in
            guard let weatherInfo = self?.decodeFetchedWeather(fetchedData: result),
                  let request = self?.endPoint.makeURLRequest(iconId: weatherInfo.iconId) else { return }
            
            self?.provider.fetchData(request: request) { result in
                let iconData = try? self?.verifyResult(result: result)
                completion(iconData)
            }
        }
    }
    
    private func decodeFetchedWeather(fetchedData: (Result<Data, NetworkError>)) -> DailyWeather.WeatherInfo? {
        guard let data = try? self.verifyResult(result: fetchedData),
              let dailyWeather = DecodeManager().decode(data: data, type: DailyWeather.self),
              let weatherInfo = dailyWeather.information.first  else { return nil }
        
       return weatherInfo
    }
    
    private func verifyResult<T, E: Error>(result: Result<T, E>) throws -> T {
        switch result {
        case.success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
}

extension DiaryService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
        case .denied:
            print("GPS 권한 요청 거부됨")
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        let longitude: CLLocationDegrees = location.coordinate.longitude
        let latitude: CLLocationDegrees = location.coordinate.latitude

        self.latitude = Double(latitude)
        self.longitude = Double(longitude)
        
        manager.stopUpdatingLocation()
    }
}
