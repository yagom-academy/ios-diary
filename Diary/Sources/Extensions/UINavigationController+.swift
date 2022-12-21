//
//  UINavigationController+.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

extension UINavigationController {
    func setDefaultNavigationAppearance() {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        self.navigationBar.scrollEdgeAppearance = navigationAppearance
    }
}
