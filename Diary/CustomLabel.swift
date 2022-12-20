//
//  CustomLabel.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/20.
//

import UIKit

final class CustomLabel: UILabel {
    init(font: UIFont.TextStyle = .body) {
        super.init(frame: .zero)
        self.font = .preferredFont(forTextStyle: font)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
