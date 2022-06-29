//
//  WeatherService.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/29.
//

import CoreLocation

struct WeatherService {
  func fetch(
    latitude: CLLocationDegrees,
    longitude: CLLocationDegrees,
    completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
      
    guard let url = URL(string: "\(APIOption.baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(APIOption.apiKey)") else {
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, reponse, error in
      guard error == nil else {
        return completion(.failure(.wrongRequest))
      }
      
      guard let httpResponse = (reponse as? HTTPURLResponse),
            (200...300).contains(httpResponse.statusCode) else {
        return completion(.failure(.wrongResponse))
      }
      
      guard let data = data else {
        return completion(.failure(.wrongResponse))
      }
      
      guard let json = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
        return completion(.failure(.docodingFail))
      }
      
      completion(.success(json))
    }.resume()
  }
  
  func fetchImage(_ iconID: String,
                  completion: @escaping (Result<Data, NetworkError>) -> Void) {
    guard let url = URL(string: "http://openweathermap.org/img/wn/\(iconID)@2x.png") else {
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, reponse, error in
      guard error == nil else {
        return completion(.failure(.wrongRequest))
      }
      
      guard let httpResponse = (reponse as? HTTPURLResponse),
            (200...300).contains(httpResponse.statusCode) else {
        return completion(.failure(.wrongResponse))
      }
      
      guard let data = data else {
        return completion(.failure(.wrongResponse))
      }
      
      completion(.success(data))
    }.resume()
  }
}
