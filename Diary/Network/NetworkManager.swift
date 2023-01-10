//
//  NetworkManager.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/03.
//

import Foundation

enum NetworkError: Error {
    case responseError
    case invalidData
    case invalidURL
    case decodingError
}

final class NetworkManager: Networkable {
    static let shared = NetworkManager()
}
