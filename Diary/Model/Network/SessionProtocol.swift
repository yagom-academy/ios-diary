//
//  SessionProtocol.swift
//  Diary
//
//  Created by Kiwon Song on 2022/08/30.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with request: APIRequest,
                                completionHandler: @escaping (Result<Data, Error>) -> Void)
}
