//
//  OpenWeatherEndpoint.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/09.
//

import Foundation

struct OpenWeatherEndpoint: EndpointMakable {
    private(set) var baseURL: String = "https://api.openweathermap.org"
    private(set) var path: String = "/data/2.5/weather"
    private(set) var method: String = HTTPMethod.get
    private(set) var queryItems: [URLQueryItem] = []
    private(set) var header: [String: String]?
    
    mutating func updateQuery(lat: String, lon: String) {
        queryItems.removeAll()
        
        queryItems.append(URLQueryItem(name: "appid", value: "999fe28a79a2691ec4db3d709dca4e4d"))
        queryItems.append(URLQueryItem(name: "lat", value: lat))
        queryItems.append(URLQueryItem(name: "lon", value: lon))
    }
    
    func makeURLRequest(iconId: String) -> URLRequest? {
        let urlText = "https://openweathermap.org/img/wn/\(iconId)@2x.png"
        
        guard let url = URL(string: urlText ) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return request
    }
}
