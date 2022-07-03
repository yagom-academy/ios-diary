//
//  OpenWeatherModel.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/07/01.
//

import Foundation

struct OpenWeatherModel: Decodable {
    let coordination: Coordination
    let weather: [Weather]

    private enum CodingKeys: String, CodingKey {
        case coordination = "coord"
        case weather
    }
}

struct Coordination: Decodable {
    let latitude: Double
    let longitube: Double

    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitube = "lon"
    }
}

struct Weather: Decodable {
    let id: Int
    let icon: String
    let main: String
    let description: String
}
