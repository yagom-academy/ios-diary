//
//  ReuseIdentifying.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/16.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
