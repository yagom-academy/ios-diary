//
//  NetworkError.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/08.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "찾을 수 없는 URL 입니다."
        }
    }
}
