//
//  ReuseIdentifiable.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/01.
//

protocol ReuseIdentifiable {
    static var indentifier: String { get }
}

extension ReuseIdentifiable {
    static var indentifier: String {
        return String(describing: self)
    }
}
