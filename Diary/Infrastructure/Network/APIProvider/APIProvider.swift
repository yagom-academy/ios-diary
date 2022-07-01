//
//  NetworkManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/28.
//

import Foundation

final class APIProvider {
    private let session: URLSession
    private var bodyParameters: Encodable?
    private var headers: [String: String]?
    
    init(session: URLSession = URLSession.shared,
         bodyParameters: Encodable? = nil,
         headers: [String: String]? = [:]
    ) {
        self.session = session
        self.bodyParameters = bodyParameters
        self.headers = headers
    }
    
    @discardableResult
    func request(
        endpoint: Endpoint,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) -> URLSessionDataTask? {
        let urlRequest = generateUrlRequest(by: endpoint)
        
        switch urlRequest {
        case .success(let urlRequest):
            let task = session.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    completion(.failure(.responseError))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.responseError))
                    return
                }
                
                guard (200..<300).contains(response.statusCode) else {
                    completion(.failure(.invalidHttpStatusCodeError(statusCode: response.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.emptyDataError))
                    return
                }
                completion(.success(data))
            }
            task.resume()
            return task
        case .failure(let error):
            completion(.failure(error))
            return nil
        }
    }
}

extension APIProvider {
    private func generateUrlRequest(by endpoint: Endpoint) -> Result<URLRequest, NetworkError> {
        let url = generateURL(by: endpoint)
        var urlRequest: URLRequest
        
        switch url {
        case .success(let url):
            urlRequest = URLRequest(url: url)
        case .failure(let error):
            return .failure(error)
        }
        
        if let bodyParameters = bodyParameters?.toDictionary() {
            switch bodyParameters {
            case .success(let body):
                if body.isEmpty == false {
                    do {
                        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
                    } catch {
                        return .failure(.decodeError)
                    }
                }
            case .failure(let error):
                return .failure(error)
            }
        }
        
        urlRequest.httpMethod = endpoint.method.rawValue
        headers?.forEach {
            urlRequest.setValue($1, forHTTPHeaderField: $0)
        }
        
        return .success(urlRequest)
    }
    
    private func generateURL(by endpoint: Endpoint) -> Result<URL, NetworkError> {
        let fullPath = "\(endpoint.baseURL)\(endpoint.path)"
        guard var urlComponents = URLComponents(string: fullPath) else {
            return .failure(.urlComponentError)
        }
        
        var urlQueryItems = [URLQueryItem]()
        if let queryParameters = endpoint.queryParameters?.toDictionary() {
            switch queryParameters {
            case .success(let data):
                data.forEach {
                    urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
                }
            case .failure(let error):
                return .failure(error)
            }
        }
        
        urlComponents.queryItems = urlQueryItems.isEmpty == false ? urlQueryItems : nil
        
        guard let url = urlComponents.url else {
            return .failure(.urlComponentError)
        }
        
        return .success(url)
    }
}

fileprivate extension Encodable {
    func toDictionary() -> Result<[String: Any], NetworkError> {
        do {
            let data = try JSONEncoder().encode(self)
            guard let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return .failure(.decodeError)
            }
            return .success(jsonData)
        } catch {
            return .failure(.decodeError)
        }
    }
}
