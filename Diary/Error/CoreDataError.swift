//
//  CoreDataError.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/09/11.
//

import Foundation

enum CoreDataError: LocalizedError {
    case notFoundData
    
    var errorDescription: String? {
        switch self {
        case .notFoundData:
            return "일치하는 데이터를 찾지 못했습니다."
        }
    }
}
