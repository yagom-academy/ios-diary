//
//  StubNetworkManager.swift
//  DiaryTests
//
//  Created by 이태영 on 2023/01/04.
//

import Foundation
@testable import Diary

final class StubNetworkManager: NetworkService {
    private let session = StubURLSession()
    var data: Data?
    
    func requestData<T>(
        endPoint: Requesting,
        type: T.Type,
        completion: @escaping (T) -> Void
    ) {
        guard let request = endPoint.convertURL() else { return }
        
        let task = session.dataTask(with: request) { data, _, _ in
            self.data = data
        }
        
        task.resume()
    }
}
