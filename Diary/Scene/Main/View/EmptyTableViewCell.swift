//
//  EmptyTableViewCell.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/16.
//

import UIKit

final class EmptyTableViewCell: UITableViewCell, Identifiable {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemRed
    label.textAlignment = .center
    label.text = "에러: 데이터를 가져올 수 없습니다."
    label.font = UIFont.preferredFont(forTextStyle: .title3)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    contentView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
}
