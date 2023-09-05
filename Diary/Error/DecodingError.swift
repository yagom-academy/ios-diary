//
//  DecodingError.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/30.
//

import Foundation

enum DecodingError: LocalizedError {
    case decodingFailure
    
    var errorDescription: String? {
        switch self {
        case .decodingFailure:
            return "디코딩 에러입니다."
        }
    }
}
