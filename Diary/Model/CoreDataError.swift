//
//  CoreDataError.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/08.
//

import Foundation

enum CoreDataError: LocalizedError {
    case persistentLoadError
    case createError
    case fetchError
    case updateError
    case deleteError
    
    var errorDescription: String? {
        switch self {
        case .persistentLoadError:
            return "영구저장소 로딩 실패"
        case .createError:
            return "생성 실패"
        case .fetchError:
            return "불러오기 실패"
        case .updateError:
            return "업데이트 실패"
        case .deleteError:
            return "삭제 실패"
        }
    }
}
