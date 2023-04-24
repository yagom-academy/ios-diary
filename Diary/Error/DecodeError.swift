//
//  DecodeError.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/24.
//

import Foundation

enum DecodeError: LocalizedError {
    case invalidFileError
    case decodingFailureError
    
    var errorDescription: String? {
        switch self {
        case .invalidFileError:
            return "해당 file이 존재하지 않습니다."
        case .decodingFailureError:
            return "해당 file을 디코딩할 수 없습니다."
        }
    }
}
