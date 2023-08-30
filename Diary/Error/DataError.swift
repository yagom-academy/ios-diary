//
//  DataError.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import Foundation

enum DataError: LocalizedError {
    case notFoundAsset
    case failedDecoding
    
    var errorDescription: String? {
        switch self {
        case .notFoundAsset:
            return "Asset을 찾을 수 없습니다."
        case .failedDecoding:
            return "Decoding에 실패하였습니다."
        }
    }
}
