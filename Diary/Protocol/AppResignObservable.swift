//
//  AppResignObservable.swift
//  Diary
//
//  Created by Erick on 2023/09/10.
//

import UIKit

protocol AppResignObservable {
    func addObserveWillResignActive(observer: Any, selector: Selector)
}

extension AppResignObservable {
    func addObserveWillResignActive(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
}
