//
//  CoreDataUpdatable.swift
//  Diary
//
//  Created by Erick on 2023/09/09.
//

import Foundation

protocol CoreDataUpdatable {
    func addObserveSuccessUpdate(observer: Any, selector: Selector)
    func addObserveFailUpdate(observer: Any, selector: Selector)
}

extension CoreDataUpdatable {
    func addObserveSuccessUpdate(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .coreDataUpdateSuccessNotification, object: nil)
    }
    
    func addObserveFailUpdate(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .coreDataUpdateFailNotification, object: nil)
    }
}
