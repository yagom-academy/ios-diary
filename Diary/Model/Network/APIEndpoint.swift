//
//  APIEndpoint.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/10.
//

import Foundation

protocol APIEndpoint {
    associatedtype APIResponse: Decodable
    
    var decoder: DecodingUtility { get }
    var method: HTTPMethod { get }
    var baseURLLiteral: String { get }
    var path: String { get }
    var url: URL? { get }
    var headers: [String: String]? { get }
    var queries: [String: String?] { get }
}

extension APIEndpoint {
    var decoder: DecodingUtility {
        return JSONDecodingUtility()
    }
    
    var url: URL? {
        guard let url = URL(string: baseURLLiteral)?.appendingPathComponent(path) else {
            return nil
        }
        
        var urlComponents = URLComponents(string: url.absoluteString)
        let quries = self.queries.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        urlComponents?.queryItems = quries
        return urlComponents?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        
        if let headers = self.headers {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}
