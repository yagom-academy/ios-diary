//
//  Requestable.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/09.
//

import Foundation

protocol Requestable {
    var urlComponents: URLComponents? { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
}
