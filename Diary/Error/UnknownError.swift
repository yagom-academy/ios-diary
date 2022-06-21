//
//  UnknownError.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

enum UnknownError: Error, ErrorAlertProtocol {
    case unknownError
    
    var alertTitle: String {
        return "명시되지 않은 에러"
    }
    var alertMessage: String {
        return "명시되지 않은 에러가 발생했습니다."
    }
}
