//
//  Error.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import Foundation

enum DataError: Error {
    case noneDataError
    case decodeError
    case noneTitleError
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noneDataError:
            return "데이터가 없습니다."
        case .decodeError:
            return "DECODE ERROR"
        case .noneTitleError:
            return "제목을 입력해주세요"
        }
    }
}
