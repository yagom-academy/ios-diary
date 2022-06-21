//
//  CoreDataError.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

enum CoreDataError: Error, ErrorAlertProtocol {
    case createError
    case readError
    case updateError
    case deleteError
    
    var alertTitle: String {
        return "데이터 베이스 접근중 오류가 발생했습니다."
    }
    var alertMessage: String {
        switch self {
        case .createError:
            return "생성에 실패했습니다."
        case .readError:
            return "읽기에 실패했습니다."
        case .updateError:
            return "업데이트에 실패했습니다."
        case .deleteError:
            return "삭제에 실패하였습니다."
        }
    }
}
