//
//  CoreDataError.swift
//  Diary
//
//  Created by Seoyeon Hong on 2023/05/07.
//

import Foundation

enum CoreDataError: LocalizedError, CustomStringConvertible {
    
    case fetchandLoadError
    case saveError
    case deleteError
    case updateError

    var description: String {
        switch self {
        case .fetchandLoadError:
            return "FETCHANDLOAD_ERROR"
        case .saveError:
            return "SAVE_ERROR"
        case .deleteError:
            return "DELETE_ERROR"
        case .updateError:
            return "UPDATE_ERROR"
        }
    }
    
    var userErrorMessage: String {
        switch self {
        case .fetchandLoadError:
            return "데이터를 불러오는데 실패했습니다. 다시 시도해주세요."
        case .saveError:
            return "데이터 저장에 실패했습니다. 다시 시도해주세요."
        case .deleteError:
            return "일기 삭제에 실패했습니다. 다시 시도해주세요."
        case .updateError:
            return "일기 수정에 실패했습니다. 다시 시도해주세요."
        }
    }
    
}
