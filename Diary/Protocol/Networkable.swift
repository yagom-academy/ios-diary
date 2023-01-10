//
//  Networkable.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/10.
//

import Foundation

protocol Networkable {
    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void)
}
