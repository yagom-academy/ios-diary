//
//  StubURLSession.swift
//  DiaryTests
//
//  Created by 이태영 on 2023/01/04.
//

import Foundation
@testable import Diary

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

final class StubURLSession {
    func dataTask(
        with request: URL,
        completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTask {
        let sessionDataTask = StubURLSessionDataTask()
        
        let response = HTTPURLResponse(
            url: request,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        sessionDataTask.completion = {
            completionHandler(WeatherEntity.mockData, response, nil)
        }
        
        return sessionDataTask
    }
}

final class StubURLSessionDataTask: URLSessionDataTask {
    var completion: () -> Void = { }
    
    override func resume() {
        completion()
    }
}
