//
//  Location.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/27.
//

import Foundation

final class Location {
    static let shared = Location()
    
    private init() {}
    
    private var latitude: Double?
    private var longitude: Double?
    
    func configure(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getLocation() -> (latitude: Double, longitude: Double)? {
        guard let lat = latitude, let lon = longitude else {
            return nil
        }
        
        return (lat, lon)
    }
}
