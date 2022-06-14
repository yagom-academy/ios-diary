//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/14.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell, Identifierable {
  private let titleLabel = UILabel()
  private let bodyLabel = UILabel()
  private let dateLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUp(diary: Diary) {
    self.titleLabel.text = diary.title
    self.bodyLabel.text = diary.body
    self.dateLabel.text = diary.createdAtString
  }

  private func configure() {
    self.accessoryType = .disclosureIndicator

    self.titleLabel.font = .preferredFont(forTextStyle: .title3)
    self.titleLabel.adjustsFontForContentSizeCategory = true

    self.dateLabel.font = .preferredFont(forTextStyle: .subheadline)
    self.dateLabel.adjustsFontForContentSizeCategory = true
    self.dateLabel.setContentHuggingPriority(.required, for: .horizontal)
    self.dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

    self.bodyLabel.font = .preferredFont(forTextStyle: .caption2)
    self.bodyLabel.adjustsFontForContentSizeCategory = true

    let subContainer = UIStackView(arrangedSubviews: [dateLabel, bodyLabel])
    subContainer.axis = .horizontal
    subContainer.spacing = 5.0

    let container = UIStackView(arrangedSubviews: [titleLabel, subContainer])
    container.axis = .vertical
    container.spacing = 8.0
    container.translatesAutoresizingMaskIntoConstraints = false

    self.contentView.addSubview(container)
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
      container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
      container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
      container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
}
