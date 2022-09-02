//
//  NameSpace.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/09/02.
//

enum APIkey {
    static let key = "ac5efdadaefb0e36d41b927e210a8792"
}

enum WeatherIcon {
    static func makeURL(icon: String) -> String {
        return "http://openweathermap.org/img/wn/\(icon)@2x.png"
    }
}
