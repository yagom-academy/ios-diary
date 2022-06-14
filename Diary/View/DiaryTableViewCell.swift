//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/14.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
  private let titleLabel = UILabel()
  private let bodyLabel = UILabel()
  private let dateLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configure()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func configure() {
    self.accessoryType = .disclosureIndicator

    self.titleLabel.text = "타이틀"
    self.titleLabel.font = .preferredFont(forTextStyle: .title3)
    self.titleLabel.adjustsFontForContentSizeCategory = true

    self.dateLabel.text = "20XX년 XX월 XX일"
    self.dateLabel.font = .preferredFont(forTextStyle: .subheadline)
    self.dateLabel.adjustsFontForContentSizeCategory = true
    self.dateLabel.setContentHuggingPriority(.required, for: .horizontal)
    self.dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

    self.bodyLabel.text = "본문입니다."
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
