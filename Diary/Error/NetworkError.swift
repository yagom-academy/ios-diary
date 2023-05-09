//
//  NetworkError.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/09.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidRequestError
    case invalidResponseError
    case unknownError
    case failToParse
    
    var errorDescription: String? {
        switch self {
        case .invalidRequestError:
            return "잘못된 요청입니다."
        case .invalidResponseError:
            return "알 수 없는 응답 에러입니다."
        case .unknownError:
            return "알 수 없는 에러입니다."
        case .failToParse:
            return "디코딩 에러가 발생했습니다."
        }
    }
}
