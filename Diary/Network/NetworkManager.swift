//
//  NetworkManager.swift
//  Diary
//
//  Created by Max, Hemg on 2023/09/13.
//

import CoreLocation

final class NetworkManager {
    private var dataTask: URLSessionDataTask?
    
    func fetchData(url: String, completionHandler: @escaping(Result<Data, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(.requestFail))
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299) ~= httpResponse.statusCode else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            guard let data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
        self.dataTask?.resume()
    }
    
    func fetchLocation(location: CLLocation, _ completionHandler: @escaping(Result<WeatherResult, APIError>) -> Void) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=aaa5700cbd82d1a09e738731002f97be"
        
        fetchData(url: urlStr) { result in
            switch result {
            case .success(let data):
                do {
                    let decodingData: WeatherResult = try DecodingManager.decodeData(from: data)
                    completionHandler(.success(decodingData))
                } catch {
                    completionHandler(.failure(APIError.decodingFail))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
