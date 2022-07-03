//
//  Network.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/07/01.
//

import Foundation

struct Network: Networkable {
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

protocol Networkable {
    var session: URLSessionProtocol { get }
    
    func requestData(
        _ url: URL,
        completionHandler: @escaping (Data, URLResponse) -> Void,
        errorHandler: @escaping (Error) -> Void
    )
}

extension Networkable {

    func requestData(
        _ url: URL,
        completionHandler: @escaping (Data, URLResponse) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) {
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                errorHandler(NetworkError.sessionError)
                return
            }
            guard let response = response,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200..<300).contains(statusCode) else {
                errorHandler(NetworkError.statusCodeError)
                return
            }
            guard let data = data else {
                errorHandler(NetworkError.dataError)
                return
            }
            completionHandler(data, response)
        }
        dataTask.resume()
    }
}
