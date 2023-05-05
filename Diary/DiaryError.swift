//
//  DiaryError.swift
//  Diary
//
//  Created by 리지, Goat on 2023/05/04.
//

enum DiaryError: Error {
    case decodeFailure
    case networkUnknown
    case networkResponse
    case networkStatusCode
}
