//
//  MockSession.swift
//  DiaryTests
//
//  Created by 김동용 on 2022/08/30.
//
@testable import Diary
import UIKit
final class MockSession: SessionProtocol {
    func dataTask<T: Decodable>(with request: APIRequest, completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let fileLocation = Bundle.main.url(forResource: "MockData", withExtension: "json")
        else { return }
        guard let mockData = try? Data(contentsOf: fileLocation) else { return }
        
        guard let model = try? JSONDecoder().decode(T.self, from: mockData) else {
            completionHandler(.failure(NetworkError.invalidData))
            return
        }
        
        completionHandler(.success(model))
    }
}
