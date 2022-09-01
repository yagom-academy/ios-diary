//
//  APIError.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/29.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case failedToDecode
    case failedToConvert
    case emptyData
    case unknownErrorOccured
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "URL is not valid."
        case .failedToDecode:
            return "Falied to decode response data."
        case .failedToConvert:
            return "Failed to convert response data"
        case .emptyData:
            return "There is no data."
        case .unknownErrorOccured:
            return "Unknown error occured."
        }
    }
}
