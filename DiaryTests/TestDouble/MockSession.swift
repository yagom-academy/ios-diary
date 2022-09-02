//
//  MockSession.swift
//  DiaryTests
//
//  Created by Kiwi, Brad. on 2022/09/02.
//

import Foundation

final class MockSession: SessionProtocol {
    func dataTask(with request: APIRequest,
                  completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let mockData = MockData(fileName: "sampleWeather").data else {
            completionHandler(.failure(CodableError.decode))
            return
        }
        completionHandler(.success(mockData))
    }
}
