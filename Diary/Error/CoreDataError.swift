//
//  CoreDataError.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/28.
//

import Foundation

enum CoreDataError: String, LocalizedError {
    case persistentContainerError
    case saveContextError
    case fetchError
    case deleteError
    
    var errorDescription: String {
        switch self {
        case .persistentContainerError:
            return "컨테이너에서 오류 바인딩을 실패하였습니다."
        case .saveContextError:
            return "컨텍스트 저장을 실패하였습니다."
        case .fetchError:
            return "컨텍스트 패치를 실패하였습니다."
        case .deleteError:
            return "삭제에 실패하였습니다."
        }
    }
}
