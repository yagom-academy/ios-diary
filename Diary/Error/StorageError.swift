//
//  AssetError.swift
//  Diary
//
//  Created by Erick on 2023/08/31.
//

import Foundation

enum StorageError: LocalizedError {
    case loadDataFailed
    case storeDataFailed
    case updateDataFailed
    case deleteDataFailed
    
    public var errorDescription: String? {
        switch self {
        case .loadDataFailed:
            return "데이터 로드를 실패했습니다."
        case .storeDataFailed:
            return "데이터 저장을 실패했습니다."
        case .updateDataFailed:
            return "데이터 업데이트를 실패했습니다."
        case .deleteDataFailed:
            return "데이터 삭제를 실패했습니다."
        }
    }
}
