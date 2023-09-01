//
//  AssetError.swift
//  Diary
//
//  Created by Erick on 2023/08/31.
//

import Foundation

enum StorageError: LocalizedError {
    case loadDataFailed
    
    public var errorDescription: String? {
        switch self {
        case .loadDataFailed:
            return "저장소에서 데이터 로드에 실패했습니다."
        }
    }
}
