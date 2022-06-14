//
//  DetailView.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

final class DetailView: UIView {
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(textView)
        setConsantrait()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("디테일뷰 초기화 안됨")
    }
    
    private func setConsantrait() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            textView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            textView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setData(with diary: DiaryData) {
        textView.text = diary.body
    }
}
