//
//  DiaryError.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/26.
//

import Foundation

enum DiaryError: LocalizedError {
    case invalidFile
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidFile:
            return "Asset 파일명이 잘못되었습니다."
        case .decodingFailed:
            return "디코딩에 실패하였습니다."
        }
    }
}
