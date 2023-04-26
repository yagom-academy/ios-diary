//
//  NetworkError.swift
//  Diary
//
//  Created by Seoyeon Hong on 2023/04/26.
//

import Foundation

enum NetworkError: LocalizedError, CustomStringConvertible {
    
    case dataAssetNotFound
    case decodingFailure
    
    var description: String {
        switch self {
        case .dataAssetNotFound:
            return "DATA_ASSET_NOT_FOUND"
        case .decodingFailure:
            return "DECODING_FAILURE"
        }
    }
    
    var userErrorMessage: String {
        switch self {
        case .dataAssetNotFound:
            return "데이터를 불러오는데 문제가 발생했습니다. 다시 시도해주세요."
        case .decodingFailure:
            return "일기 정보를 처리하는데 실패했습니다. 다시 시도해주세요."
        }
    }
    
}
