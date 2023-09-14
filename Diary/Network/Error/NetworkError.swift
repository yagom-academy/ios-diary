//
//  NetworkError.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/14.
//

enum NetworkError: Error {
    case invalidURL
    case failureRequest
    case failureResponse
    case invalidDataType
    
    var description: String {
        switch self {
        case .invalidURL:
            return "url형식이 잘못되었습니다"
        case .failureRequest:
            return "데이터 요청에 실패했습니다."
        case .failureResponse:
            return "응답이 없습니다."
        case .invalidDataType:
            return "올바르지 않는 데이터 포맷입니다"
        }
    }
}
