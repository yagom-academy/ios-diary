//
//  DecodeError.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/08/30.
//

import Foundation

enum DecodeError: LocalizedError {
    case assetNotFound
    case failed
    
    var errorDescription: String? {
        switch self {
        case .assetNotFound:
            return "에셋 파일을 찾을 수 없습니다."
        case .failed:
            return "디코딩에 실패했습니다."
        }
    }
}
