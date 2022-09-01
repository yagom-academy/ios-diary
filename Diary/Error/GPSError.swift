//
//  GPSError.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/29.
//

import Foundation

enum GPSError: Error, LocalizedError {
    case noAuthorization
    case noLocation
    
    var errorDescription: String? {
        switch self {
        case .noAuthorization:
            return NSLocalizedString("There is no authorization to fetch GPS", comment: "GPS Error")
        case .noLocation:
            return NSLocalizedString("There is no location data", comment: "Location Error")
        }
    }
}
