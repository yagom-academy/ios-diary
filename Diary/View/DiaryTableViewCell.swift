//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/24.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let diaryInfoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        infoLabel.text = nil
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        diaryInfoStackView.addArrangedSubview(titleLabel)
        diaryInfoStackView.addArrangedSubview(infoLabel)
        contentView.addSubview(diaryInfoStackView)
        
        NSLayoutConstraint.activate([
            diaryInfoStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                    constant: 8),
            diaryInfoStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                       constant: -8),
            diaryInfoStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                        constant: 8),
            diaryInfoStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                         constant: -8)
        ])
    }
    
    func configureLabel(diaryData: DiaryData) {
        guard let title = diaryData.title else { return }
        let dateText = DateManger.shared.convertToDate(fromDouble: diaryData.createDate)
        
        titleLabel.text = title
        
        if let body = diaryData.body {
            infoLabel.text = dateText + "  " + body
        } else {
            infoLabel.text = dateText
        }
        infoLabel.attributeText(targetString: dateText)
    }
}

extension UILabel {
    func attributeText(targetString: String) {
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        
        attributedString.addAttribute(.font,
                                      value: UIFont.preferredFont(forTextStyle: .callout),
                                      range: range)
        self.attributedText = attributedString
    }
}
