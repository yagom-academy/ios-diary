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
            return "없는 파일"
        case .decodingFailed:
            return "디코딩 실패"
        }
    }
}
