//
//  DetailView.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/22.
//

import UIKit

final class BaseTextView: UIView {
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
  
  func updateTextView(diary: Diary) {
    guard let title = diary.title,
          let body = diary.content else {
      return
    }
    let content = title + "\n" + body
    textView.text = content
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
