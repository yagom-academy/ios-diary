//
//  DetailView.swift
//  Diary
//
//  Created by LIMGAUI on 2022/06/22.
//

import UIKit

final class DetailView: UIView {
  let textView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateTextView(diary: Diary) {
    self.textView.text = diary.content
  }
  
  private func configureLayout() {
    self.addSubview(textView)
    
    NSLayoutConstraint.activate([
      self.textView.topAnchor.constraint(equalTo: topAnchor),
      self.textView.bottomAnchor.constraint(equalTo: bottomAnchor),
      self.textView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      self.textView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
    ])
  }
}
