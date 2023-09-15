//
//  NetworkManager.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/14.
//

import Foundation

enum NetworkAPI {}

extension NetworkAPI {
    struct URLInfo {
        let scheme: String
        let host: String
        let port: Int?
        let path: String
        let query: [String: String]?
        
        init(scheme: String = "https", host: String, port: Int? = nil, path: String, query: [String: String]? = nil) {
            self.scheme = scheme
            self.host = host
            self.port = port
            self.path = path
            self.query = query
        }
    }
}

extension NetworkAPI.URLInfo {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        components.path = path
        components.queryItems = query?.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        
        return components.url
    }
}

extension NetworkAPI.URLInfo {
    static func weatherAPI(path: String) -> Self {
        Self.init(host: "api.openweathermap.org", path: path, query: ["lat": "44.34", "lon": "10.99"])
    }
}

extension NetworkAPI {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
}

extension NetworkAPI {
    struct RequestInfo<T: Encodable> {
        var method: Method
        var headers: [String: String]?
        var parameters: T?
        
        init(method: Method, headers: [String: String]? = nil, parameters: T? = nil) {
            self.method = method
            self.headers = headers
            self.parameters = parameters
        }
    }
}

extension NetworkAPI.RequestInfo {
    func requests(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = parameters.flatMap { try? JSONEncoder().encode($0) }
        headers.map {
            request.allHTTPHeaderFields?.merge($0) { lhs, _ in lhs }
        }
        
        return request
    }
}

protocol NetworkAPIDefinition {
    typealias URLInfo = NetworkAPI.URLInfo
    typealias RequestInfo = NetworkAPI.RequestInfo
    
    associatedtype Parameter: Encodable
    associatedtype Response: Decodable
    
    var urlInfo: URLInfo { get }
    var requestInfo: RequestInfo<Parameter> { get }
}

extension NetworkAPIDefinition {
    func request(completion: @escaping ((Result<Response, Error>) -> Void)) {
        guard let url = urlInfo.url else {
            return
        }
        
        let request = requestInfo.requests(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}

struct EmptyParameter: Codable {}

struct EmptyResponse: Codable {}

enum WeatherAPI2 {}

extension WeatherAPI2 {
    struct Users: NetworkAPIDefinition {
        let urlInfo: URLInfo
        let requestInfo: RequestInfo<EmptyParameter> = .init(method: .get)
        
        init() {
            self.urlInfo = .weatherAPI(path: "/data/2.5/weather")
        }
        
        typealias Response = Location
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: URLalbe>(API: T, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let APIUrl = API.url,
              let url = URL(string: APIUrl) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.failureRequest))
                return
            }

            guard let response = response,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.failureResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidDataType))
                return
            }

            completion(.success(data))
        }
        
        task.resume()
    }
}
