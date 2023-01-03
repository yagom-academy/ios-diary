//
//  NetworkManager.swift
//  Diary
//
//  Created by Kyo, Baem on 2023/01/03.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(url: URL, completion: @escaping (Result<WeatherData, SessionError>) -> Void) {
        
        let decodeManager = DecoderManager<WeatherData>()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let sesseion = URLSession(configuration: .default)
        
        sesseion.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.networkError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noneDataError))
                return
            }
            
            let weatherData = decodeManager.decodeData(data)
            
            switch weatherData {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage) -> Void) {
        let imageURL = url
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: data) else { return }
            completion(image)
        }
    }
}
