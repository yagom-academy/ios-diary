//
//  Endpoint.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation

enum Endpoint {
    static func request(for api: API) -> URLRequest? {
        var urlComponents = URLComponents(string: api.baseURL + api.path)

        urlComponents?.queryItems = api.queries
        
        guard let url = urlComponents?.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        
        api.headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
}
