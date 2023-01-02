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
    
    func setRightButton(systemName: String, action: UIAction) {
        let button = UIBarButtonItem(image: UIImage(systemName: systemName), primaryAction: action)
        self.rightBarButtonItem = button
    }
    
    func setRightButton(systemImage: UIImage?, action: UIAction) {
        let button = UIBarButtonItem(image: systemImage, primaryAction: action)
        self.rightBarButtonItem = button
    }
}
