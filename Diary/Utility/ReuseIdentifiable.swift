//
//  ReuseIdentifiable.swift
//  Diary
//
//  Created by Mary & Whales on 2023/09/04.
//

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
