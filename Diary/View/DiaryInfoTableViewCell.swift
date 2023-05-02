//
//  DiaryInfoTableViewCell.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import UIKit

final class DiaryInfoTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        dateLabel.text = nil
        bodyLabel.text = nil
    }
    
    func configureLabel(item: Diary) {
        guard let content = item.content else { return }
        let parsingDiary = content.split(separator: "\n").map { String($0) }
        
        let titleIndex = parsingDiary.firstIndex { str in
            !str.replacingOccurrences(of: " ", with: "").isEmpty
        }
        
        guard let titleIndex = titleIndex else { return }
        
        let bodyIndex = titleIndex + 1
        let body = parsingDiary[bodyIndex...].map { String($0) }.joined(separator: "\n")
        titleLabel.text = parsingDiary[titleIndex]
        dateLabel.text = Date.convertToDate(by: item.date)
        bodyLabel.text = body
    }
}

// MARK: UI
extension DiaryInfoTableViewCell {
    private func configureCell() {
        let dateAndBodyStackView = UIStackView(arrangedSubviews: [dateLabel, bodyLabel])
        
        dateAndBodyStackView.spacing = 5
        
        let diaryStackView = UIStackView(arrangedSubviews: [titleLabel, dateAndBodyStackView])
        
        diaryStackView.axis = .vertical
        diaryStackView.spacing = 5
        diaryStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(diaryStackView)
        
        NSLayoutConstraint.activate([
            diaryStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 3),
            diaryStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            diaryStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -3),
            diaryStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -3)
        ])
    }
}
