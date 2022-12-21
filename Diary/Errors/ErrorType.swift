//
//  ErrorType.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/21.
//

enum ErrorType: Error {
    case decodeFailed
    case dataAssetLoadFailed
    
    var alertTitle: String {
        switch self {
        case .decodeFailed:
            return "데이터 디코딩 실패"
        case .dataAssetLoadFailed:
            return "데이터 에셋 로딩 실패"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .decodeFailed:
            return "데이터 디코딩 에러가 발생했습니다."
        case .dataAssetLoadFailed:
            return "해당하는 데이터 에셋이 존재하지 않습니다."
        }
    }
}
