//
//  DiaryError.swift
//  Diary
//
//  Created by 리지, Goat on 2023/05/04.
//

enum DiaryError: Error {
    case decodeFailure
    case networkUnknown
    case networkResponse
    case networkStatusCode(code: Int)
    
    var description: String {
        switch self {
        case .networkUnknown:
            return "알수없는 오류"
        case .networkResponse:
            return "httpResponse 오류"
        case .networkStatusCode(code: let code):
            return "상태코드 \(code) 오류"
        case .decodeFailure:
            return "데이터 전환 실패"
        }
    }
}
