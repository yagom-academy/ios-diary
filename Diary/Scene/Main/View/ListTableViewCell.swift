//
//  ListTableViewCell.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/14.
//

import UIKit

final class ListTableViewCell: UITableViewCell, Identifiable {
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
    configureUI()
    accessoryType = .disclosureIndicator
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(diary: Diary) {
    dateLabel.text = diary.createdDate?.setKoreaDateFormat(dateFormat: .yearMonthDay)
    titleLabel.text = diary.title
    descriptionLabel.text = diary.content
  }
  
  private func configureUI() {
    contentView.addSubview(mainStackView)
    mainStackView.addArrangedSubviews(titleLabel, bottomStackView)
    bottomStackView.addArrangedSubviews(dateLabel, descriptionLabel)
  
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
    ])
  }
}
