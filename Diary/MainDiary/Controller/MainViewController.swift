//
//  Diary - ViewController.swift
//  Created by Quokka Taeangel.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
  private lazy var baseView = MainView(frame: view.bounds)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
  }
  
  private func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.navigationItem.title = "일기장"
    self.navigationItem.rightBarButtonItem = createAddBarButtonItem()
    self.view = baseView
  }
  
  private func createAddBarButtonItem() -> UIBarButtonItem {
    return UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  }
}
