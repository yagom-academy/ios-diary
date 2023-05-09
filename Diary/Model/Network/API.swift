//
//  API.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

protocol API {
    var baseURL: String { get }
    var path: String { get }
    var queries: [String: String] { get set }
    var headers: [String: String] { get set }
}
