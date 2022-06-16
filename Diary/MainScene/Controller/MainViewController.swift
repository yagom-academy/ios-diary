//
//  Diary - ViewController.swift
//  Created by Quokka Taeangel.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
  private lazy var baseView = MainView(frame: view.bounds)
  private var diary: [Diary]?
  
  override func loadView() {
    super.loadView()
    self.view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.saveJsonData()
  }
  
  private func saveJsonData() {
    self.diary = PassorManager.fetchDiary()
  }
  
  private func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.navigationItem.title = "일기장"
    self.navigationItem.rightBarButtonItem = createAddBarButtonItem()
    self.baseView.tableView.register(
      MainTableViewCell.self,
      forCellReuseIdentifier: MainTableViewCell.identifier
    )
    self.baseView.tableView.register(
      MainTableViewCell.self,
      forCellReuseIdentifier: EmptyTableViewCell.identifier
    )
    self.baseView.tableView.dataSource = self
  }
  
  private func createAddBarButtonItem() -> UIBarButtonItem {
    return UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addButtonDidTap)
    )
  }
  
  @objc private func addButtonDidTap() {
    let detailVC = WriteViewController()
    navigationController?.pushViewController(detailVC, animated: true)
  }
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.diary?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: MainTableViewCell.identifier,
      for: indexPath
    )
            as? MainTableViewCell,
          let diary = self.diary else {
      return EmptyTableViewCell()
    }
    
    cell.updata(diary: diary[indexPath.row])
    
    return cell
  }
}
