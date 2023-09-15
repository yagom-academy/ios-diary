//
//  NetworkError.swift
//  Diary
//
//  Created by 김민성 on 2023/09/15.
//

import Foundation

enum NetworkError: Error {
    case invalidIcon
    case invalidURL
    case invalidHTTPResponse
    case badStatusCode
}
