//
//  WriteDiaryView.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/15.
//

import UIKit

final class WriteDiaryView: UIView {
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
