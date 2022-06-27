//
//  DetailView.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/22.
//

import UIKit

final class DetailView: WriteView {
  func updateTextView(diary: Diary) {
    guard let title = diary.title,
          let body = diary.content else {
      return
    }
    let content = title + "\n" + body
    textView.text = content
  }
}
