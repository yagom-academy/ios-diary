//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/15.
//

import UIKit

final class WriteDiaryViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
  }
  
  private func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.navigationItem.title = createTodayDate()
  }
  
  private func createTodayDate() -> String {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy년 MM월 dd일"
    return dateformatter.string(from: Date())
  }
}
