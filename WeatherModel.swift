//
//  WeatherData.swift
//  Diary
//
//  Created by 변재은 on 2022/09/01.
//

import Foundation

struct WeatherModel: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
