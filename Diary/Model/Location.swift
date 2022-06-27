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
    
    private var lat: Double?
    private var lon: Double?
    
    func configure(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    func getLocation() -> (lat: Double, lon: Double)? {
        guard let lat = lat, let lon = lon else {
            return nil
        }
        
        return (lat, lon)
    }
}
