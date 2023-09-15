//
//  NetworkAPI.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/15.
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
    static func weatherAPI(host: String, path: String, query: [String: String]?) -> Self {
        Self.init(host: host, path: path, query: query)
    }
}
