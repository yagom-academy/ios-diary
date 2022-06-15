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
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy년 MM월 dd일"
    let currentDate = dateformatter.string(from: Date())
    label.text = currentDate
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "두두 정말정말정말정말나빳다"
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
  
  private func configureUI() {
    self.addSubview(mainStackView)
    self.mainStackView.addArrangedSubview(titleLabel)
    self.mainStackView.addArrangedSubview(bottomStackView)
    self.bottomStackView.addArrangedSubview(dateLabel)
    self.bottomStackView.addArrangedSubview(descriptionLabel)
    
    NSLayoutConstraint.activate([
      self.mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      self.mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      self.mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      self.mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
}
