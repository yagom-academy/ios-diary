//
//  WeatherError.swift
//  Diary
//
//  Created by 백곰,주디 on 2022/08/31.
//

import Foundation

enum WeatherError: Error {
    case failResponse
    case noneData
}

extension WeatherError {
    var message: String {
        switch self {
        case .failResponse:
            return "정보 불러오기를 실패했습니다."
        case .noneData:
            return "데이터가 없습니다."
        }
    }
}
