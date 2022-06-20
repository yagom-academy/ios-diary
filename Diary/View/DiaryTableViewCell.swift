//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/14.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
  static let identifier = "DiaryTableViewCell"

  private let titleLabel = UILabel().then {
    $0.font = .preferredFont(forTextStyle: .title3)
    $0.adjustsFontForContentSizeCategory = true
  }
  private let bodyLabel = UILabel().then {
    $0.font = .preferredFont(forTextStyle: .caption2)
    $0.adjustsFontForContentSizeCategory = true
  }
  private let dateLabel = UILabel().then {
    $0.font = .preferredFont(forTextStyle: .subheadline)
    $0.adjustsFontForContentSizeCategory = true
    $0.setContentHuggingPriority(.required, for: .horizontal)
    $0.setContentCompressionResistancePriority(.required, for: .horizontal)
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initializeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.titleLabel.text = nil
    self.bodyLabel.text = nil
    self.dateLabel.text = nil
  }

  func configureItem(_ diary: Diary) {
    self.titleLabel.text = diary.title
    self.bodyLabel.text = diary.body
    self.dateLabel.text = Formatter.changeToString(from: diary.createdAt)
  }

  private func initializeUI() {
    self.accessoryType = .disclosureIndicator

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
