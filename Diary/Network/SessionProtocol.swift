//
//  SessionProtocol.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/29.
//

import UIKit

protocol SessionProtocol {
    func dataTask<T: Codable>(with request: APIRequest, completionHandler: @escaping (Result<T, Error>) -> Void)
}
