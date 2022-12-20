//
//  IdentifierReusable.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

protocol IdentifierReusable { }

extension IdentifierReusable {
    static var reuseIdentifier: String {
        return String.init(describing: self)
    }
}
