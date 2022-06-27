//
//  OpenWeatherAPI.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/24.
//

struct OpenWeatherAPI: APIable {
    let baseURL: String = "https://api.openweathermap.org/data/2.5/weather"
    let path: String = ""
    let queryParameters: [String: String]?
    let httpMethod: HTTPMethod = .get
}

struct OpenWeatherIconImageAPI: APIable {
    let baseURL: String = "https://openweathermap.org/img/wn/"
    let path: String
    let queryParameters: [String: String]? = nil
    let httpMethod: HTTPMethod = .get
}
