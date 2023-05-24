//
//  NetworkError.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/08.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case transportFailed(Error)
    case clientError(Int)
    case serverError(Int)
    case unknown(Int)
    case dataNotFound
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "찾을 수 없는 URL 입니다."
        case .transportFailed(let error):
            return "통신 오류 - \(error)"
        case .clientError(let code):
            return "클라이언트 오류 - \(code)"
        case .serverError(let code):
            return "서버 오류 - \(code)"
        case .unknown(let code):
            return "알 수 없는 오류 - \(code)"
        case .dataNotFound:
            return "데이터를 찾을 수 없습니다."
        case .invalidResponse:
            return "유효한 응답이 아닙니다."
        }
    }
}
