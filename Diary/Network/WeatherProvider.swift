//
//  WeatherProvider.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/09.
//

import Foundation

protocol Provider {
    associatedtype Target
    func fetchData<T: Decodable>(_ target: Target,
                                 type: T.Type,
                                 completion: @escaping (Result<T, Error>) -> Void)
}

final class WeatherProvider<Target: Requestable>: Provider {
    func fetchData<T>(_ target: Target,
                      type: T.Type,
                      completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        guard let endPoint = self.makeEndpoint(for: target),
              let request = endPoint.urlRequest() else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let result = self.checkError(with: data, response, error)
            switch result {
            case .success(let data):
                do {
                    let decodeData = try JSONDecoder().decode(type, from: data)
                    completion(.success(decodeData))
                } catch NetworkError.invalidResponseError {
                    completion(.failure(NetworkError.invalidResponseError))
                } catch {
                    completion(.failure(NetworkError.failToParse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func checkError(with data: Data?,
                    _ response: URLResponse?,
                    _ error: Error?
    ) -> Result<Data, Error> {
        if let _ = error {
            return .failure(NetworkError.unknownError)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkError.unknownError)
        }
        
        guard (200...399).contains(httpResponse.statusCode) else {
            switch httpResponse.statusCode {
            case 400...499:
                return .failure(NetworkError.invalidRequestError)
            case 500...599:
                return .failure(NetworkError.invalidResponseError)
            default:
                return .failure(NetworkError.unknownError)
            }
        }
        
        guard let data = data else {
            return .failure(NetworkError.unknownError)
        }
        
        return .success(data)
    }
}

extension WeatherProvider {
    func makeEndpoint(for target: Requestable) -> Endpoint? {
        guard let url = target.urlComponents?.url else {
            return nil
        }
        
        return Endpoint(url: url.absoluteString, method: .get, headers: target.headers)
    }
}

final class Endpoint {
    let url: String
    let method: HttpMethod
    let headers: [String: String]?
    
    init(url: String, method: HttpMethod, headers: [String: String]?) {
        self.url = url
        self.method = method
        self.headers = headers
    }
}

extension Endpoint {
    func urlRequest() -> URLRequest? {
        guard let requestURL = URL(string: url) else {
            return nil
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        
        headers?.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol Requestable {
    var urlComponents: URLComponents? { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
}

enum WeatherAPI {
    case weather
}

extension WeatherAPI: Requestable {
    var urlComponents: URLComponents? {
        var components = URLComponents(string: baseURL)
        components?.path = self.path
        
        var queriesItem: [URLQueryItem] = []
        self.queries.forEach { queryItem in
            let queryItem = URLQueryItem(name: queryItem.key, value: queryItem.value)
            queriesItem.append(queryItem)
        }
        
        components?.queryItems = queriesItem
        
        return components
    }
    
    var baseURL: String {
//        return "http://kobis.or.kr"
        return "https://api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .weather:
            return "/data/2.5/weather"
        }
    }
    
    var queries: [String: String] {
        switch self {
        case .weather:
            return ["appid": self.key, "lat": "44.34", "lon": "10.99"]
        }
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var key: String {
//        get {
//          guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
//            fatalError("Info.plist를 찾지 못했습니다.")
//          }
//
//          let plist = NSDictionary(contentsOfFile: filePath)
//          guard let value = plist?.object(forKey: "API_KEY") as? String else {
//            fatalError("Info.plist에서 API_KEY를 찾을 수 없습니다.")
//          }
//
//          return value
//        }
        return "be61fea903194c94cb32f87980cbf5dc"
    }
    
    var headers: [String: String]? {
        return nil
    }
}
