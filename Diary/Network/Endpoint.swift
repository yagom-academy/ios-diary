//
//  Endpoint.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/09.
//

import Foundation

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
