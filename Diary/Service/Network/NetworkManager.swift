//
//  NetworkManager.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/24.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case invalidURLRequest
    case invalidHTTPResponse
    case invalidData
    case decodingFail
    case unknown
}

struct NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(api: APIable) async throws -> T {
        guard let urlRequest = api.urlRequest else {
            throw NetworkError.invalidURLRequest
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode else {
            throw NetworkError.invalidHTTPResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFail
        }
    }
    
    func requestImage(api: APIable) -> Task<UIImage, Error> {
        return Task {
            guard let urlRequest = api.urlRequest else {
                throw NetworkError.invalidURLRequest
            }
            
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode else {
                throw NetworkError.invalidHTTPResponse
            }
            
            guard let image = UIImage(data: data) else {
                throw NetworkError.invalidData
            }
            
            return image
        }
    }
}
