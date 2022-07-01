//
//  DiaryCell.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import UIKit

final class DiaryCell: UITableViewCell {
    private let baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        
        return imageView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private var imageDownloadTask: Task<Data, Error>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownloadTask?.cancel()
        weatherImageView.image = nil
    }
    
    // MARK: - Funcitons
    
    private func attribute() {
        accessoryType = .disclosureIndicator
    }
    
    private func addSubviews() {
        bottomStackView.addArrangedSubviews(dateLabel, weatherImageView, contentLabel)
        baseStackView.addArrangedSubviews(titleLabel, bottomStackView)
        
        contentView.addSubview(baseStackView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            baseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            baseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            baseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalToConstant: 30),
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor)
        ])
    }
    
    func setUpItem(with diary: Diary) {
        titleLabel.text = diary.title
        dateLabel.text = diary.createdDate.formattedString
        setUpImage(with: diary.weather?.icon)
        contentLabel.text = diary.body
    }
    
    private func setUpImage(with url: String?) {
        guard let url = url else { return }
        
        let openWeatherIconImageAPI = OpenWeatherIconImageAPI(imageURL: url)
        imageDownloadTask = NetworkManager().request(api: openWeatherIconImageAPI)
        
        Task {
            guard let imageData = try await imageDownloadTask?.value else { return }
            weatherImageView.image = UIImage(data: imageData)
        }
    }
}
