//  Diary - DiaryCell.swift
//  Created by Ayaan, zhilly on 2022/12/20

import UIKit

final class DiaryCell: UITableViewCell {
    static let identifier: String = String(describing: DiaryCell.self)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dateAndBodyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        dateAndBodyStackView.addArrangedSubview(createdDateLabel)
        dateAndBodyStackView.addArrangedSubview(bodyLabel)
        contentsStackView.addArrangedSubview(titleLabel)
        contentsStackView.addArrangedSubview(dateAndBodyStackView)
        addSubview(contentsStackView)
        
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        createdDateLabel.setContentHuggingPriority(.required, for: .horizontal)
        createdDateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func setupDiary(_ newDiary: Diary) {
        titleLabel.text = newDiary.title
        createdDateLabel.text = newDiary.createdAt
        bodyLabel.text = newDiary.body
    }
}
