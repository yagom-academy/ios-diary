//
//  SendDataDelegate.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/22.
//

protocol SendDataDelegate: AnyObject {
    func sendData<T>(_ data: T)
}
