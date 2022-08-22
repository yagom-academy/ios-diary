//
//  ReuseIdentifying.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/22.
//

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
