//
//  UIViewController +.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

extension UIViewController {
    convenience init(backgroundColor: UIColor) {
        self.init()
        
        self.view.backgroundColor = backgroundColor
    }
}
