//
//  WeatherAPIManager.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/27.
//

import Foundation

enum EntryPoint {
    case weatherDescription(lat: Double, lon: Double)
    case image(icon: String)
    
    static let apiKey = "0a518df9455c6866d0ea3034b559e8d5"
    
    static let hostURL = "https://api.openweathermap.org/data/2.5/weather?"
    static let imageURL = "http://openweathermap.org/img/wn/"
    
    var url: URL? {
        switch self {
        case .weatherDescription(let lat, let lon):
            return URL(string: EntryPoint.hostURL + "lat=\(lat)&lon=\(lon)&appid=\(EntryPoint.apiKey)")
        case .image(let icon):
            return URL(string: EntryPoint.imageURL + "\(icon)@2x.png")
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode(statusCode: Int?)
    case emptyData
    case responseError(error: Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalidURL"
        case .invalidStatusCode(let statusCode):
            return "statusCode: \(String(describing: statusCode))"
        case .emptyData:
            return "emptyData"
        case .responseError(let error):
            return "respondError: \(String(describing: error))"
        }
    }
}

final class WeatherAPIManager {
    
    func fetchData(url: URL?, complition: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let url = url else {
            complition(.failure(.invalidURL))
            return nil
        }

        let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            if let error = error {
                return complition(.failure(.responseError(error: error)))
            }
            
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                complition(.failure(.invalidStatusCode(statusCode: (urlResponse as? HTTPURLResponse)?.statusCode)))
                return
            }
            
            guard let data = data else {
                return complition(.failure(.emptyData))
            }

            complition(.success(data))
        }
        
        task.resume()
        
        return task
    }
}
