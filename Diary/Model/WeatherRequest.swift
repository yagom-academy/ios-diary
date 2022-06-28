//
//  WeatherRequest.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/28.
//

import Foundation

struct WeatherRequest: Encodable {
    var latitude: Double?
    var longitude: Double?
    var appId: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case appId = "APPID"
    }
}
