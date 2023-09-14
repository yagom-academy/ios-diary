//
//  Location.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/14.
//

struct Location: Decodable {
    let coordinate: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let date: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    
    private enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather, base, main, visibility, wind, clouds
        case date = "dt"
        case sys, timezone, id, name, cod
    }
}

struct Coordinate: Decodable {
    let longitude: Double
    let latitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct Weather: Decodable {
    let id: Int
    let main, description, icon: String
}

struct Clouds: Decodable {
    let all: Int
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

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}
