//
//  DecodingError.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/14.
//

enum DecodingError: Error {
    case decodingFailure
    
    var description: String {
        switch self {
        case .decodingFailure:
            return "디코딩을 실패하였습니다."
        }
    }
}
