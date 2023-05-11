//
//  DecodeError.swift
//  Diary
//
//  Created by Jinah Park on 2023/05/11.
//

import Foundation

enum DecodeError: LocalizedError {
    case decodingFailureError
    
    var errorDescription: String? {
        switch self {
        case .decodingFailureError:
            return "해당 file을 디코딩할 수 없습니다."
        }
    }
}
