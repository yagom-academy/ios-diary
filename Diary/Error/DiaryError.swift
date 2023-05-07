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
    case invalidContainer
    case saveFailed
    case fetchFailed
    case initFailed
    case invalidContents
    
    var errorDescription: String? {
        switch self {
        case .invalidFile:
            return "Asset 파일명이 잘못되었습니다."
        case .decodingFailed:
            return "디코딩에 실패하였습니다."
        case .invalidContainer:
            return "코어데이터 저장소 로드에 실패하였습니다."
        case .saveFailed:
            return "코어데이터 저장소 저장에 실패하였습니다."
        case .fetchFailed:
            return "코어데이터 데이터 읽기에 실패하였습니다."
        case .initFailed:
            return "관리자에게 문의하세요."
        case .invalidContents:
            return "존재하지 않는 글입니다."
        }
    }
}
