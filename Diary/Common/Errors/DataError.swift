//
//  DataError.swift
//  Diary
//
//  Created by leewonseok on 2022/12/27.
//

import Foundation

enum DataError: Error {
    case contextUndifined
    case entityUndifined
    case emptyData
    case unChangedData
}
