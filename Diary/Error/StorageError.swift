//
//  AssetError.swift
//  Diary
//
//  Created by Erick on 2023/08/31.
//

import Foundation

enum StorageError: LocalizedError {
    case loadDataFailed
    case saveDataFailed
    
    var errorDescription: String? {
        switch self {
        case .loadDataFailed:
            return "데이터 로드를 실패했습니다."
        case .saveDataFailed:
            return "데이터 로드를 실패했습니다."
        }
    }
}
