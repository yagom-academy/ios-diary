//
//  MainTableViewCell.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/14.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
  private let mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 2
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title3)
    return label
  }()

  private let bottomStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 5
    stackView.axis = .horizontal
    return stackView
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .footnote)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .footnote)
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configureUI()
    accessoryType = .disclosureIndicator
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupDateForrmat(date: TimeInterval) -> String {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy년 MM월 dd일"
    let currentDate = dateformatter.string(from: Date(timeIntervalSince1970: date))
    return currentDate
  }
  
  func updata(diary: Diary) {
    self.titleLabel.text = diary.title
    self.dateLabel.text = setupDateForrmat(date: diary.createdAt)
    self.descriptionLabel.text = diary.body
  }
  
  private func configureUI() {
    contentView.addSubview(mainStackView)
    self.mainStackView.addArrangedSubviews(titleLabel, bottomStackView)
    self.bottomStackView.addArrangedSubviews(dateLabel, descriptionLabel)
  
    NSLayoutConstraint.activate([
      self.mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      self.mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      self.mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      self.mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
    ])
  }
}
