//
//  CoreDataError.swift
//  Diary
//
//  Created by Derrick, Hugh on 2022/08/27.
//

enum CoreDataError: Error {
    case noneEntity
    case fetchFailure
    
    var message: String {
        switch self {
        case .noneEntity:
            return "Entity가 존재하지 않습니다."
        case .fetchFailure:
            return "연결에 실패했습니다."
        }
    }
}

