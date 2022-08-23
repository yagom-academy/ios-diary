//
//  ReuseIdentifiable.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/21.
//

protocol ReuseIdentifiable {
    static var identifier: String { get }
}

extension ReuseIdentifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
