//
//  DiaryError.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/22.
//

import Foundation

enum DiaryError: LocalizedError {
    case loadFail
    case saveFail
    
    var errorDescription: String? {
        switch self {
        case .loadFail:
            return "데이터를 불러오지 못했습니다."
        case .saveFail:
            return "데이터를 저장하지 못했습니다."
        }
    }
}
