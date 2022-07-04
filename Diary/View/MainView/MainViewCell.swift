//
//  MainViewCell.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

final class MainViewCell: UITableViewCell {
    private enum Constant {
        static let lineInset: CGFloat = 8
        static let sideInset: CGFloat = 20
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        setConsantrait()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "questionmark.circle")
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, weatherImageView, descriptionLabel])
        contentView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = Constant.lineInset
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setConsantrait() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.lineInset),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constant.sideInset),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constant.lineInset),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -Constant.lineInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.lineInset),
            stackView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),

            weatherImageView.widthAnchor.constraint(equalToConstant: 26),
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor)
        ])
    }
    
    func setDiaryData(_ data: DiaryInfo) {
        var bodies = data.body?.components(separatedBy: "\n")
        bodies?.removeFirst()
        let body = bodies?.reduce("") { $0 + " " + $1 }
        // icon
//        if let icon = data.icon {
//            weatherImageView.weatherImage(icon: icon)
//        }
        titleLabel.text = data.title
        dateLabel.text = data.date?.toString ?? ""
        descriptionLabel.text = body
    }
    
    func setWeatherImage(_ data: DiaryInfo) {
            if let icon = data.icon {
                weatherImageView.weatherImage(icon: icon)
        }
    }
}
