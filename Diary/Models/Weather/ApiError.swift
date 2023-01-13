//
//  ApiError.swift
//  Diary
//
//  Created by Mangdi, junho lee, on 2023/01/03.
//

import Foundation

enum ApiError: CustomStringConvertible, Error {
    case wrongUrlError
    case unknownError
    case statusCodeError
    case jsonDecodingError

    var description: String {
        switch self {
        case .wrongUrlError:
            return NSLocalizedString("Invalid URL address error.", comment: "")
        case .unknownError:
            return NSLocalizedString("An unknown error has occurred.", comment: "")
        case .statusCodeError:
            return NSLocalizedString("Status code error occurred.", comment: "")
        case .jsonDecodingError:
            return NSLocalizedString("Error occurred during Json Decoding.", comment: "")
        }
    }
}
