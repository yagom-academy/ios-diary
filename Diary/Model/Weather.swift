//
//  Weather.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/28.
//

struct WeatherResponse: Decodable {
  let weather: [Weather]
}

struct Weather: Decodable {
  let main: String
  let icon: String
}
