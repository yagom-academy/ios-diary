//
//  URLSessionGenerator.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/23.
//

import Foundation

enum EndPoint {
    case weatherInfo(lat: Double, lon: Double)
    case weatherIcon
    
    var url: URL? {
        switch self {
        case .weatherInfo(let lat, let lon):
            return URL(string: "")
        case .weatherIcon:
            return URL(string: "")
        }
    }
}

final class URLSessionManager {
    private let session: URLSession = URLSession.shared
    
    func request(endpoint: EndPoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = endpoint.url else {
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request, completionHandler: completion).resume()
    }
}
