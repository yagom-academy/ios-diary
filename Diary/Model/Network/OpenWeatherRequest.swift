//
//  OpenWeatherRequest.swift
//  Diary
//
//  Created by Kiwon Song on 2022/08/30.
//

import Foundation

struct OpenWeatherRequest: APIRequest {
    var method: HTTPMethod
    var baseURL: String
    var headers: [String: String]?
    var query: [String: String]?
    var path: String
}
