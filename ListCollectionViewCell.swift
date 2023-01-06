//
//  ListCollectionViewCell.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewListCell {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: .none)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .none)
        
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        
        return imageView
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .none)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.configureMainStackView()
        self.contentView.addSubview(self.mainStackView)
        
        NSLayoutConstraint.activate([
            self.mainStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.mainStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.mainStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.weatherImageView.widthAnchor.constraint(equalToConstant: 25),
            self.weatherImageView.heightAnchor.constraint(equalTo: self.weatherImageView.widthAnchor)
        ])
        
        self.dateLabel.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        self.weatherImageView.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        self.weatherImageView.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
    }
    
    private func configureMainStackView() {
        self.configureSubStackView()
        self.mainStackView.addArrangedSubview(self.titleLabel)
        self.mainStackView.addArrangedSubview(self.subStackView)
    }
    
    private func configureSubStackView() {
        self.subStackView.addArrangedSubview(self.dateLabel)
        self.subStackView.addArrangedSubview(self.weatherImageView)
        self.subStackView.addArrangedSubview(self.bodyLabel)
    }
    
    func configureContents(with diary: DiaryModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = diary.title
            self.dateLabel.text = diary.createdAt.convertDate()
            self.bodyLabel.text = diary.body
            
            if diary.weatherIconID.isEmpty { return }
            
            self.weatherImageView.loadView(imageID: diary.weatherIconID)
            
        }
    }
}
