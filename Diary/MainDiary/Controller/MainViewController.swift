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
    self.baseView.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
    baseView.tableView.dataSource = self
  }
  
  private func createAddBarButtonItem() -> UIBarButtonItem {
    return UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  }
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell  else {
      return UITableViewCell()
    }
  
    return cell
  }
}
