//
//  Diary - DecodeError.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
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
