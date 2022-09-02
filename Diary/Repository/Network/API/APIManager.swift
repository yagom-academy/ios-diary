//
//  APIManager.swift
//  Diary
//
//  Created by Hugh, Derrick kim on 2022/08/29.
//

import Foundation

struct APIManager {
    var configuration: APIConfiguration

    init?(url: String, latitude: Double, longitude: Double) {
        guard var urlComponents = URLComponents(string: url) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: WeatherAPIConst.latitude, value: "\(latitude)"),
            URLQueryItem(name: WeatherAPIConst.longitude, value: "\(longitude)"),
            URLQueryItem(name: WeatherAPIConst.appID, value: WeatherAPIConst.key)]
        
        guard let url = urlComponents.url else {
            return nil
        }

        self.configuration = APIConfiguration(url: url)
    }
    
    func requestAndDecode<T: Decodable>(using client: APIClient = APIClient.shared,
                                        dataType: T.Type,
                                        completion: @escaping (Result<T,APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        request.httpMethod = "GET"
        
        client.requestData(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let decodedData = try decoder.decode(T.self,
                                                         from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.failedToDecode))
                }
            case .failure(_):
                completion(.failure(.emptyData))
            }
        }
    }
}
