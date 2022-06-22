//
//  Diary - ViewController.swift
//  Created by Quokka Taeangel.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
  private lazy var baseView = ListView(frame: view.bounds)
  private var diarys: [Diary]? {
    didSet {
      self.baseView.tableView.reloadData()
    }
  }
  
  override func loadView() {
    super.loadView()
    self.view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.diarys = CoredataManager.sherd.readContext()
  }
  
  private func configureUI() {
    self.navigationItem.title = "일기장"
    self.navigationItem.rightBarButtonItem = createAddBarButtonItem()
    self.baseView.tableView.register(
      ListTableViewCell.self,
      forCellReuseIdentifier: ListTableViewCell.identifier)
    self.baseView.tableView.register(
      ListTableViewCell.self,
      forCellReuseIdentifier: EmptyTableViewCell.identifier)
    self.baseView.tableView.dataSource = self
    self.baseView.tableView.delegate = self
  }
  
  private func createAddBarButtonItem() -> UIBarButtonItem {
    return UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addButtonDidTap)
    )
  }
  
  @objc private func addButtonDidTap() {
    let detailViewController = WriteViewController()
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}

// MARK: TableViewDataSource

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.diarys?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: ListTableViewCell.identifier,
      for: indexPath) as? ListTableViewCell,
         let diary = self.diarys else {
      return EmptyTableViewCell()
    }
    
    cell.update(diary: diary[indexPath.row])
    
    return cell
  }
}

// MARK: TableViewDelegate

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let diary = diarys?[indexPath.row] else {
      return
    }
    let detailViewController = DetailViewController(diary: diary)
    
    self.navigationController?.pushViewController(detailViewController, animated: true)
  }
}
