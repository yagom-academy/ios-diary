//
//  CoreDataError.swift
//  Diary
//  Created by inho, dragon on 2022/1/2.
//

import Foundation

enum CoreDataError: Error {
    case appDelegateError
    case entityError
    case fetchError
    case saveError
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .appDelegateError:
            return NSLocalizedString("appDelegate error", comment: "시스템 오류가 발생했습니다.")
        case .entityError:
            return NSLocalizedString("entity error", comment: "시스템 오류가 발생했습니다.")
        case .fetchError:
            return NSLocalizedString("fetch error", comment: "데이터를 불러오는데 실패했습니다.")
        case .saveError:
            return NSLocalizedString("save error", comment: "데이터를 저장하는데 실패했습니다.")
        }
    }
}
