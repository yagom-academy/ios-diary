//
//  CoreDataUpdatable.swift
//  Diary
//
//  Created by Erick on 2023/09/09.
//

import Foundation

protocol CoreDataUpdatable {
    func addObserveSuccessUpdate(observer: Any, selector: Selector)
    func addObserveFailedUpdate(observer: Any, selector: Selector)
}

extension CoreDataUpdatable {
    func addObserveSuccessUpdate(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .coreDataUpdateSuccessNotification, object: nil)
    }
    
    func addObserveFailedUpdate(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .coreDataUpdateFailedNotification, object: nil)
    }
}
