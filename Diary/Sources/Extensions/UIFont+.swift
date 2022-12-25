//
//  UIFont+.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

extension UIFont {
    static var boldTitle1: UIFont? {
        guard let descriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .title1)
            .withSymbolicTraits(.traitBold) else {
            return nil
        }
        
        return UIFont(descriptor: descriptor, size: .zero)
    }
}
