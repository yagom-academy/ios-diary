//
//  DiaryError.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/26.
//

enum DiaryError: Error, CustomStringConvertible {
    case invalidFile
    case decodingFailed
    
    var description: String {
        switch self {
        case .invalidFile:
            return "Asset 파일명이 잘못되었습니다."
        case .decodingFailed:
            return "디코딩에 실패하였습니다."
        }
    }
}
