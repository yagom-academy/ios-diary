//
//  DiaryDetailViewController.swift
//  Created by Minseong, Lingo
//

import UIKit

final class DiaryDetailViewController: UIViewController {
  private let titleLabel = UILabel()
  private let bodyText = UITextView()
  private let diary: Diary

  init(diary: Diary) {
    self.diary = diary
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configure()
  }

  private func configure() {
    self.title = formatNumberToDateString(from: diary.createdAt)
    self.view.backgroundColor = .systemBackground

    self.titleLabel.font = .preferredFont(forTextStyle: .headline)
    self.titleLabel.adjustsFontForContentSizeCategory = true
    self.titleLabel.text = diary.title

    self.bodyText.font = .preferredFont(forTextStyle: .body)
    self.bodyText.adjustsFontForContentSizeCategory = true
    self.bodyText.text = diary.body

    let container = UIStackView(arrangedSubviews: [titleLabel, bodyText])
    container.axis = .vertical
    container.spacing = 20.0

    self.view.addSubview(container)
    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
      container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
      container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0)
    ])
  }

  private func formatNumberToDateString(from dateNumber: Int) -> String {
    let date = Date(timeIntervalSince1970: Double(dateNumber))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월 dd일"

    return dateFormatter.string(from: date)
  }
}
