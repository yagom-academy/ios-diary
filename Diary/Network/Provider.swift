//
//  Provider.swift
//  Diary
//
//  Created by kimseongjun on 2023/05/09.
//

import Foundation

struct Provider {
    func loadOpenWeatherAPI<T: Decodable>(endpoint: EndpointMakeable, parser: Parser<T>, completion: @escaping (T) -> Void) {
        guard let request = endpoint.makeURLRequest() else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            
            guard let httpURLResponse = response as? HTTPURLResponse, (200...299).contains(httpURLResponse.statusCode) else { return }
            
            guard let validData = data, let parsedData = parser.parse(data: validData) else { return }
            completion(parsedData)
        }
        dataTask.resume()
    }
}
