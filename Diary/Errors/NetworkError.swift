//
//  NetworkError.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2023/01/04.
//

enum NetworkError: Error {
    case clientError
    case missingData
    case serverError
    
    var alertTitle: String {
        return "날씨정보 불러오기 실패"
    }
    
    var alertMessage: String {
        return "다시 한번 시도해주세요"
    }
}
