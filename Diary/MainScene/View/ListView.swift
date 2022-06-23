//
//  ListView.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/14.
//

import UIKit

final class ListView: UIView {
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureLayout()
    self.backgroundColor = .systemBackground
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureLayout() {
    self.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      self.tableView.topAnchor.constraint(equalTo: topAnchor),
      self.tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      self.tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      self.tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
    ])
  }
}
