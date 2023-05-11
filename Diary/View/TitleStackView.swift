//
//  TitleStackView.swift
//  Diary
//
//  Created by 김성준 on 2023/05/10.
//

import UIKit

final class TitleStackView: UIStackView {

    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    func configureContent(iconData: Data, date: String) {
        configureUI()
        weatherIcon.contentMode = .scaleAspectFit
        weatherIcon.image = UIImage(data: iconData)
        dateLabel.text = date
    }
    
    private func configureUI() {
        self.addArrangedSubview(weatherIcon)
        self.addArrangedSubview(dateLabel)
        
        NSLayoutConstraint.activate ([
            weatherIcon.heightAnchor.constraint(equalToConstant: 40),
            weatherIcon.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
