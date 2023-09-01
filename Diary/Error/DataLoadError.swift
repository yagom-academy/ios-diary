//
//  LoadDataError.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/29.
//

import Foundation

enum DataLoadError: Error {
    case assetNotFound
    case decodeFailure
}

extension DataLoadError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case.assetNotFound:
            return NSLocalizedString("Asset을 찾을 수 없습니다.", comment: "Description of asset not found")
        case .decodeFailure:
            return NSLocalizedString("Decode에 실패했습니다.", comment: "Description of decode fail")
        }
    }
}
