//
//  UINavigationItem.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.
        
import UIKit

extension UINavigationItem {
    func setNavigationTitle(title: String) {
        self.title = title
    }
    
    func setRightButton(systemName: UIBarButtonItem.SystemItem, action: UIAction) {
        let button = UIBarButtonItem(systemItem: systemName, primaryAction: action)
        self.rightBarButtonItem = button
    }
}
