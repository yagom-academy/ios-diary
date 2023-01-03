//
//  WeatherData.swift
//  Diary
//
//  Created by Kyo, Baem on 2023/01/03.
//

import Foundation

struct WeatherData: Decodable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

struct Clouds: Decodable {
    let all: Int
}

struct Coord: Decodable {
    let lon, lat: Double
}

struct Main: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Rain: Decodable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

struct Sys: Decodable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

struct Weather: Decodable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}
