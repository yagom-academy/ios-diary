//
//  Error.swift
//  Diary
//
//  Created by Min Hyun on 2023/08/30.
//

enum DecodingError: Error {
    case fileNotFound
    case decodingFailure
    case unknown

    var message: String {
        switch self {
        case .fileNotFound:
            return "파일을 불러오지 못했습니다."
        case .decodingFailure:
            return "파일을 변환하지 못했습니다."
        case .unknown:
            return "알 수 없는 오류입니다."
        }
    }
}
