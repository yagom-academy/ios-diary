//
//  DecodingError.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/30.
//

enum DecodingError: Error {
    case decodingFailure
    
    var description: String {
        switch self {
        case .decodingFailure:
            return "디코딩 에러입니다."
        }
    }
}
