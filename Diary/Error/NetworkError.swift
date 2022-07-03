//
//  NetworkError.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/07/01.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case sessionError
    case statusCodeError
    case dataError
    case decodingError
}
