//
//  DiaryBaseView.swift
//  Diary
//
//  Created by LIMGAUI on 2022/06/24.
//

import UIKit

class DiaryBaseView: UIView {
  let textView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureLayout() {
    addSubview(textView)
    
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: topAnchor),
      textView.bottomAnchor.constraint(equalTo: bottomAnchor),
      textView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
    ])
  }
}
