//
//  JSONError.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/16.
//

enum JSONError: Error {
    case decodingFailure
    case noneFile
}

extension JSONError {
    var message: String {
        switch self {
        case .decodingFailure:
            return "JSON 파일 디코딩을 실패했습니다."
        case .noneFile:
            return "존재하지 않는 파일입니다."
        }
    }
}
