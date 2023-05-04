//
//  CoreDataError.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/04.
//

import Foundation

public enum CoreDataError: Error {
    case entityNotFound
    case fetchError
    case insertError
    case updateError
    case deleteError
}

extension CoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .entityNotFound:
            return NSLocalizedString("엔티티를 찾지 못하였습니다", comment: "EntityName Error")
        case .fetchError:
            return NSLocalizedString("데이터 로드에 실패하였습니다", comment: "Fetch Error")
        case .insertError:
            return NSLocalizedString("데이터 생성에 실패하였습니다", comment: "Insert Error")
        case .updateError:
            return NSLocalizedString("데이터 수정에 실패하였습니다", comment: "Update Error")
        case .deleteError:
            return NSLocalizedString("데이터 삭제에 실패하였습니다", comment: "Delete Error")
        }
    }
}
