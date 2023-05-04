//
//  ContentsTableViewCell.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/24.
//

import UIKit

final class ContentsTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = createStackView()
        configureLayout(stackView)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(title: String, description: String, date: String) {
        titleLabel.text = title
        descriptionLabel.text = date + " " + description.replacingOccurrences(of: "\n", with: "")
        descriptionLabel.applyAttribute(targetString: date)
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        return stackView
    }
    
    private func configureLayout(_ stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

private extension UILabel {
    func applyAttribute(targetString: String) {
        guard let fullText = text else { return }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)

        attributedString.addAttribute(.font,
                                      value: UIFont.preferredFont(forTextStyle: .body),
                                      range: range)
        attributedText = attributedString
    }
}
