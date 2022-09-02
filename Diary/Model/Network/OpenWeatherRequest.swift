//
//  OpenWeatherRequest.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/09/02.
//

import Foundation

struct OpenWeatherRequest: APIRequest {
    var method: HTTPMethod
    var baseURL: String
    var headers: [String: String]?
    var query: [String: String]?
    var path: String
}
