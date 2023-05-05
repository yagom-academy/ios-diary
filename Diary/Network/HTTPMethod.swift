//
//  HTTPMethod.swift
//  Diary
//
//  Created by 리지, Goat on 2023/05/05.
//

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
