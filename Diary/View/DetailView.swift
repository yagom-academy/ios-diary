//
//  DetailView.swift
//  Diary
//
//  Created by 조성훈 on 2022/06/14.
//

import UIKit

final class DetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
}
