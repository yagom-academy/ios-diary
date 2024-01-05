//
//  ReuseIdentifying.swift
//  Diary
//
//  Created by Hisop on 2024/01/05.
//

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
