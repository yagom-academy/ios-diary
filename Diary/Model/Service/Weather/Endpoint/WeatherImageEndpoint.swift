//
//  WeatherImageEndpoint.swift
//  Diary
//
//  Created by Andrew on 2023/05/12.
//

import Foundation

struct WeatherImageEndpoint: WeatherAPIInformationOwner {
    let baseURLLiteral = "https://openweathermap.org"
    let method: HTTPMethod = .get
    let path = "/img/wn/"
    let iConCode: String
    let imageInfomation = "@2x.png"
    
    var url: URL? {
        let weatherImageUrl = baseURLLiteral + path + iConCode + imageInfomation
        return URL(string: weatherImageUrl)
    }
}
