//
//  APIError.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/29.
//

import Foundation

enum APIError: Error {
    case failedToDecode
    case emptyData
    case unknownErrorOccured
    case invalidURL
}
