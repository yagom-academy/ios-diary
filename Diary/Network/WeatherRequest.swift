//
//  WeatherRequest.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/30.
//
import Foundation

struct WeatherRequest: APIRequest {
    var method: HTTPMethod {
        .get
    }
    var baseURL: String
    var headers: [String: String]?
    var query: [URLQueryItem]?
    var body: Data?
    var path: URLAdditionalPath
}
