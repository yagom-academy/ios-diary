//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 우롱차, Red on 2022/06/28.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
