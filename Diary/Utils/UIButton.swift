//
//  UIButton.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/14.
//

import UIKit

extension UIButton {
    enum SystemImage {
        static let indicator = "chevron.left"
    }
    
    convenience init(title: String?, imageName: String? = SystemImage.indicator) {
        self.init()
        self.setImage(UIImage(systemName: SystemImage.indicator), for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.setTitleColor(.systemBlue, for: .normal)
    }
}
