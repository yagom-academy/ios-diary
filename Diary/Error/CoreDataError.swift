//
//  CoreDataError.swift
//  Diary
//
//  Created by Toy, Morgan on 1/11/24.
//

enum CoreDataError: Error {
    case saveDataError
    case readDataError
}

extension CoreDataError {
    var errorDescription: String {
        switch self {
        case .saveDataError:
            return "CoreData 저장에 실패했습니다."
        case .readDataError:
            return "CoreData 를 불러오는데 실패했습니다."
        }
    }
}
