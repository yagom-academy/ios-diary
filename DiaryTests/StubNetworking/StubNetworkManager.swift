//
//  StubNetworkManager.swift
//  DiaryTests
//
//  Copyright (c) 2023 Minii All rights reserved.

@testable import Diary

extension WeatherEntity: Equatable {
    public static func == (lhs: WeatherEntity, rhs: WeatherEntity) -> Bool {
        return (lhs.main == rhs.main) && (lhs.icon == rhs.icon)
    }
    
    static var mock: Self = WeatherEntity(main: "Clear", icon: "01d")
}

class StubNetworkManager: NetworkService {
    var testedValue: WeatherEntity?
    
    func requestData<T>(
        endPoint: Requesting,
        type: T.Type,
        completion: @escaping (Decodable) -> Void
    ) {
        testedValue = WeatherEntity.mock
        completion(WeatherEntity.mock)
    }
}
