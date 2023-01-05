//
//  UITextField+.swift
//  Diary
//
//  Created by 이태영 on 2023/01/05.
//

import UIKit

extension UITextField {
    convenience init(font: UIFont?, placeholder: String? = nil) {
        self.init()
        
        self.font = font
        self.placeholder = placeholder
        self.adjustsFontForContentSizeCategory = true
        self.returnKeyType = .done
    }
    
    var filteredText: String {
        return self.text ?? ""
    }
}
