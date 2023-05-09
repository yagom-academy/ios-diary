//
//  NetworkError.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/09.
//

import Foundation

enum NetworkError: LocalizedError {
    case responseCodeError
    case invalidResponse
    case noData
    case responseError(error: Error?)
    
    var errorDescription: String? {
        switch self {
        case .responseCodeError:
            return "response error"
        case .invalidResponse:
            return "비정상적인 response입니다."
        case .noData:
            return "Data가 존재하지 않습니다."
        case .responseError(error: let error):
            return error?.localizedDescription
        }
    }
}
