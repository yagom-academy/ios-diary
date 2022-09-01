//
//  APIConfiguration.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/29.
//

import Foundation

struct APIConfiguration {
    typealias Parameters = [String: String]
    
    let url: URL
    let parameters: Parameters?
    
    init(url: URL, parameters: Parameters? = nil) {
        
        self.url = url
        self.parameters = parameters
    }
}
