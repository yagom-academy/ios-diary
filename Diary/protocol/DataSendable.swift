//
//  DataSendable.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/18.
//

import Foundation

protocol DataSendable {
    func dataTask<T>(data: T)
}
