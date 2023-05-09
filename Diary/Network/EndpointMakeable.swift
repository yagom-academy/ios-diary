//
//  EndpointMakeable.swift
//  Diary
//
//  Created by kimseongjun on 2023/05/09.
//

import Foundation

protocol EndpointMakeable {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem] { get }
    var header: [String: String]? { get }
    
    func makeURL() -> URL?
    func makeURLRequest() -> URLRequest?
}

extension EndpointMakeable {
    
    func makeURL() -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return nil }
        
        return url
    }
    
    func makeURLRequest() -> URLRequest? {
        guard let url = makeURL() else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        
        header?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        return urlRequest
    }
}
