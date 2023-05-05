//
//  Weather.swift
//  Diary
//
//  Created by 리지, Goat on 2023/05/05.
//

// MARK: - WeatherInforamtion
struct WeatherInformation: Decodable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain
    let clouds: Clouds
    let date: Int
    let system: System
    let timezone, id: Int
    let name: String
    let cod: Int
    
    private enum CodingKeys: String, CodingKey {
        case coord, weather, base, main, visibility, wind, rain, clouds
        case date = "dt"
        case system = "sys"
        case timezone, id, name, cod
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let longitude: Double
    let latitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

// MARK: - Main
struct Main: Codable {
    let temperature, feelsLike, temperatureMinimun, temperatureMaximum: Double
    let pressure, humidity, seaLevel, groundLevel: Int

    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case temperatureMinimun = "temp_min"
        case temperatureMaximum = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let per1H: Double

    enum CodingKeys: String, CodingKey {
        case per1H = "1h"
    }
}

// MARK: - Sys
struct System: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let weatherState, description, icon: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case weatherState = "main"
        case description, icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let degress: Int
    let gust: Double
    
    private enum CodingKeys: String, CodingKey {
        case speed
        case degress = "deg"
        case gust
    }
}
