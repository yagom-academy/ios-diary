//
//  APIClientLogic.swift
//  Diary
//
//  Created by Derrick kim on 9/2/22.
//

import Foundation

protocol APIClientLogic {
    func requestData(with urlRequest: URLRequest, completion: @escaping (Result<Data,APIError>) -> Void)
}
