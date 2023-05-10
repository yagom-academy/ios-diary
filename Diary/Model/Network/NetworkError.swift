//
//  NetworkError.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/10.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case unknownError
    case invalidResponse
    case invalidStatusCode(code: Int, data: Data)
    case invalidData
    case parsingFailure(decodingError: DecodingError?, data: Data)
}
