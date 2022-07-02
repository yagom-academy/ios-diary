//
//  NetworkManager.swift
//  Diary
//
//  Created by marisol on 2022/07/01.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol APIable {
    var url: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var params: [String: String]? { get }
    var iconID: String? { get }
}

struct WeatherAPI: APIable {
    var url: String = "https://api.openweathermap.org"
    var path: String = "/data/2.5/weather"
    var method: HTTPMethod = .get
    let latitude: Double
    let longitude: Double
    var params: [String: String]? {
        return ["lat": String(latitude),
                "lon": String(longitude),
                "appid": "783e209f3bc56998f3575fbe0168df43"]
    }
    var iconID: String?
}

struct ImageAPI: APIable {
    var url: String = "https://openweathermap.org"
    var path: String = "/img/w/"
    var method: HTTPMethod = .get
    var params: [String: String]? {
        return nil
    }
    var iconID: String?
}

enum NetworkError: Error {
    case error
    case statusCode
    case data
}

struct NetworkManager {
    func request(with apiAble: APIable, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let successRange = 200...299
        
        switch apiAble.method {
        case .get:
            var urlComponent = URLComponents(string: apiAble.url + apiAble.path)
            
            if let params = apiAble.params {
                urlComponent?.queryItems = params.compactMap {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
                
            } else {
                guard let iconID = apiAble.iconID else {
                    return
                }
                
                let iconParams = "\(iconID).png"
                
                urlComponent = URLComponents(string: apiAble.url + apiAble.path + iconParams)
            }
            
            guard let url = urlComponent?.url else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    completion(.failure(.error))
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    return
                }
                
                guard successRange.contains(statusCode) else {
                    completion(.failure(.statusCode))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.data))
                    return
                }
                
                completion(.success(data))
            }.resume()
        case .post:
            print(#function)
        case .patch:
            print(#function)
        case .delete:
            print(#function)
        }
    }
}
