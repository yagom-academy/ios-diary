//
//  ConversionError.swift
//  Diary
//
//  Created by Erick on 2023/09/04.
//

import Foundation

enum ConversionError: LocalizedError {
    case missingAttribute
    
    var errorDescription: String? {
        switch self {
        case .missingAttribute:
            return "속성이 누락되어 변환할 수 없습니다."
        }
    }
}
