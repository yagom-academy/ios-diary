//
//  Error.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import Foundation

enum DataError: Error {
    case noneDataError
    case noneContentError
    case coreDataError
}

enum SessionError: Error {
    case noneDataError
    case networkError
    case decodeError
    case urlError
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noneDataError:
            return "입력을 확인해주세요."
        case .noneContentError:
            return "제목을 입력해주세요"
        case .coreDataError:
            return "코어데이터 오류"
        }
    }
}
