//
//  DiaryTalbeViewCell.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/24.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    static let identifier = "DiaryTableViewCell"
    
    private var myDiary: DiaryCoreData?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 40)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private let subTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentCompressionResistancePriority(UILayoutPriority(750), for: .horizontal)
        return imageView
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(UILayoutPriority(250), for: .horizontal)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureMainStackView()
        configureSubtitleStackView()
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMainStackView() {
        self.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subTitleStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func configureSubtitleStackView() {
        subTitleStackView.addArrangedSubview(dateLabel)
        subTitleStackView.addArrangedSubview(weatherIcon)
        subTitleStackView.addArrangedSubview(bodyLabel)
        
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIcon.widthAnchor.constraint(equalTo: subTitleStackView.widthAnchor
                                               , multiplier: 0.08),
            weatherIcon.heightAnchor.constraint(equalTo: weatherIcon.widthAnchor, multiplier: 1)
            ])
    }
    
    func setupItem(item: DiaryCoreData, iconImage: UIImage?) {
        self.myDiary = item
        
        guard let myDiary = myDiary,
              let formattedDate = DateFormatterManager.shared.convertToFomattedDate(of: myDiary.date) else { return }
        
        titleLabel.text = myDiary.title
        dateLabel.text = formattedDate
        weatherIcon.image = iconImage
        bodyLabel.text = myDiary.body
    }
}
