//
//  WeatherAPIInformationOwner.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/10.
//

import Foundation

protocol WeatherAPIInformationOwner {
    var serviceKey: String { get }
    var baseURLLiteral: String { get }
}

extension WeatherAPIInformationOwner {
    var serviceKey: String {
        return "98f9b1cde083ede28714691b438bedf0"
    }
    
    var baseURLLiteral: String {
        return "http://www.openweathermap.org"
    }
}
