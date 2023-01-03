//
//  ErrorType.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/21.
//

enum DiaryError: Error {
    case fetchFailed
    case updateFailed
    case deleteFailed
    case saveContextFailed
    
    var alertTitle: String {
        switch self {
        case .fetchFailed:
            return "일기 불러오기 실패"
        case .updateFailed:
            return "일기 업데이트 실패"
        case .deleteFailed:
            return "일기 삭제 실패"
        case .saveContextFailed:
            return "일기 저장 실패"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .fetchFailed:
            return "데이터를 불러오기가 실패했습니다."
        case .updateFailed:
            return "데이터 업데이트가 실패했습니다."
        case .deleteFailed:
            return "데이터 삭제가 실패했습니다."
        case .saveContextFailed:
            return "데이터 저장이 실패했습니다."
        }
    }
}
