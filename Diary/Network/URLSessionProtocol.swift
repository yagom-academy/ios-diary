//
//  URLSessionProtocol.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/07/01.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
