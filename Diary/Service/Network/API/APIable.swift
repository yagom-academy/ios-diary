//
//  APIable.swift
//  Diary
//
//  Created by dudu, papri on 24/06/2022.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

protocol APIable {
    var baseURL: String { get }
    var path: String { get }
    var queryParameters: [String: String]? { get }
    var httpMethod: HTTPMethod { get }
}

extension APIable {
    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL + path)
        if httpMethod == .get {
            urlComponents?.queryItems = queryParameters?.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        return urlComponents?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
}
