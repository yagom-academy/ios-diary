//
//  DiaryListCell.swift
//  Diary
//
//  Created by Toy, Morgan on 1/3/24.
//

import UIKit

class DiaryListCell: UITableViewCell {

    static let identifier = String(describing: DiaryListCell.self)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    let previewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let subStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        injectAccessoryType()
        setupMainStackView()
        setupSubStackView()
        setMainStackViewConstraints()
        setSubStackViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func injectData(diary: DiaryData) {
        self.titleLabel.text = diary.title
        self.dateLabel.text = diary.date
        self.previewLabel.text = diary.body
    }
    
    func injectAccessoryType() {
        self.accessoryType = .disclosureIndicator
    }
    
    private func setupMainStackView() {
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subStackView)
        contentView.addSubview(mainStackView)
    }
    
    private func setMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupSubStackView() {
        subStackView.addArrangedSubview(dateLabel)
        subStackView.addArrangedSubview(previewLabel)
    }
    
    private func setSubStackViewConstraints() {
        NSLayoutConstraint.activate([
            subStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            subStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            subStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
    }

}
