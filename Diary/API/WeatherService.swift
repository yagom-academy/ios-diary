//
//  WeatherService.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/29.
//

import CoreLocation

struct WeatherService {

  func fetch(api: Endpoint,
                  completion: @escaping (Result<Data, NetworkError>) -> Void) {
    guard let url = api.url else {
      return completion(.failure(.wrongRequest))
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
