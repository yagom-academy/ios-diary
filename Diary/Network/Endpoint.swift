//
//  Endpoint.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation

enum Endpoint {
    static func request(for information: APIInfo) -> URLRequest? {
        var urlComponents = URLComponents(string: information.baseURL + information.path)

        urlComponents?.queryItems = information.queries
        
        guard let url = urlComponents?.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        
        information.headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
}
