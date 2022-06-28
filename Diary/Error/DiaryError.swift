//
//  DiaryError.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/20.
//

import Foundation

enum DiaryError: LocalizedError {
    case decodeError
    case invalidFileName
    
    var alertTitle: String {
        return "에러발생!"
    }
    
    var alertMessage: String {
        switch self {
        case .decodeError:
            return "디코드 오류"
        case .invalidFileName:
            return "파일명 오류"
        }
    }
}
