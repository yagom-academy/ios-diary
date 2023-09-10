//
//  CoreDataError.swift
//  Diary
//
//  Created by Max, Hemg on 2023/09/10.
//

enum CoreDataError: Error {
    case dataNotFound
    case saveFailure
    case deleteFailure
    case unknown
    
    var alertTitle: String {
        switch self {
        case .dataNotFound:
            return "로드 실패"
        case .saveFailure:
            return "저장 실패"
        case .deleteFailure:
            return "삭제 실패"
        case .unknown:
            return "오류"
        }
    }

    var message: String {
        switch self {
        case .dataNotFound:
            return "데이터를 찾지 못했습니다."
        case .saveFailure:
            return "저장에 실패하였습니다."
        case .deleteFailure:
            return "삭제에 실패하였습니다."
        case .unknown:
            return "알 수 없는 오류입니다."
        }
    }
}
