//
//  APIable.swift
//  Diary
//
//  Created by 두기, marisol on 2022/07/02.
//

protocol APIable {
    var url: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var params: [String: String]? { get }
    var iconID: String? { get }
}

struct WeatherAPI: APIable {
    var url: String = "https://api.openweathermap.org"
    var path: String = "/data/2.5/weather"
    var method: HTTPMethod = .get
    let latitude: Double
    let longitude: Double
    var params: [String: String]? {
        return ["lat": String(latitude),
                "lon": String(longitude),
                "appid": "783e209f3bc56998f3575fbe0168df43"]
    }
    var iconID: String?
}

struct ImageAPI: APIable {
    var url: String = "https://openweathermap.org"
    var path: String = "/img/w/"
    var method: HTTPMethod = .get
    var params: [String: String]? {
        return nil
    }
    var iconID: String?
}
