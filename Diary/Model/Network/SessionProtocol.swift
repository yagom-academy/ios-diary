//
//  SessionProtocol.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/09/02.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with request: APIRequest,
                                completionHandler: @escaping (Result<Data, Error>) -> Void)
}
