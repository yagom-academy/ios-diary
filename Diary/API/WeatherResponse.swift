//
//  WeatherResponse.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/29.
//

import Foundation

struct WeatherResponse: Decodable {
  let weather: [Weather]
}

struct Weather: Decodable {
  let id: Int
  let main: String
  let description: String
  let icon: String
}
