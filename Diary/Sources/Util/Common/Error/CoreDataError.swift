//
//  CoreDataError.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/26.
//

import Foundation

enum CoreDataError: Error {
    case noContext
    case failedToSave
    case unknown
    
    var errorMessage: String {
        switch self {
        case .noContext:
            return "context가 없습니다."
        case .failedToSave:
            return "저장에 실패했습니다."
        case .unknown:
            return "알 수 없는 에러입니다."
        }
    }
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noContext:
            return NSLocalizedString("No Context", comment: "Description of NoContext")
        case .failedToSave:
            return NSLocalizedString("Fail To Save", comment: "Description of Failed To Save")
        case .unknown:
            return NSLocalizedString("Unknown", comment: "Description of Unknown")
        }
    }
}
