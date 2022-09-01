//
//  URLComponentsBuilder.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/29.
//

import Foundation

final class URLComponentsBuilder {
    private var urlComponents = URLComponents()
    
    func build() -> URLComponents {
        return urlComponents
    }
    
    func setScheme(_ scheme: String) -> URLComponentsBuilder {
        urlComponents.scheme = scheme
        
        return self
    }
    
    func setHost(_ host: String) -> URLComponentsBuilder {
        urlComponents.host = host
        
        return self
    }
    
    func setPath(_ path: String) -> URLComponentsBuilder {
        urlComponents.path = path
        
        return self
    }
    
    func addQuery(items: [String: String]) -> URLComponentsBuilder {
        urlComponents.addQuery(items)
        
        return self
    }
}
