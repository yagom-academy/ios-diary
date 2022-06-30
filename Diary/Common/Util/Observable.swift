//
//  Observable.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/28.
//

import Foundation

final class HotObservable<T> {
    var value: T {
        didSet {
            self.listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}

final class ColdObservable<T> {
    private var value: T? {
        didSet {
            guard let value = value else {
                return
            }

            self.listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    func onNext(value: T) {
        self.value = value
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        self.listener = listener
    }
}
