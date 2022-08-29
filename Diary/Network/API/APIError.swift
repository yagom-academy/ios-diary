//
//  APIError.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/29.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case failedToDecode
    case emptyData
    case unknownErrorOccured
    case invalidURL
    
    var description: String {
        switch self {
        case .failedToDecode:
            return "디코딩에 실패했습니다."
        case .emptyData:
            return "데이터가 비어있습니다."
        case .unknownErrorOccured:
            return "알 수 없는 에러가 발생했습니다."
        case .invalidURL:
            return "유효하지 않는 URL주소 입니다."
        }
    }
}
