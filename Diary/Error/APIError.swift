//
//  APIError.swift
//  Diary
//
//  Created by Max, Hemg on 2023/09/13.
//

enum APIError: Error {
    case invalidURL
    case requestFail
    case invalidData
    case dataTransferFail
    case decodingFail
    case invalidHTTPStatusCode
    case requestTimeOut
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .requestFail:
            return "요청에 실패했습니다."
        case .decodingFail:
            return "디코딩 실패했습니다."
        case .invalidData:
            return "잘못된 데이터 입니다."
        case .dataTransferFail:
            return "데이터 변환에 실패했습니다."
        case .invalidHTTPStatusCode:
            return "잘못된 HTTPStatusCode입니다."
        case . requestTimeOut:
            return "요청시간이 초과되었습니다."
        }
    }
}
