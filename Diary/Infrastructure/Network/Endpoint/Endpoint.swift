//
//  Endpoint.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/28.
//

import Foundation

struct Endpoint {
    var baseURL: String
    var path: String
    var method: HttpMethod
    var queryParameters: Encodable?

    init(baseURL: String = "",
         path: String = "",
         method: HttpMethod = .get,
         queryParameters: Encodable? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
    }
}
