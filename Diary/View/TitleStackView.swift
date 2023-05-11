//
//  TitleStackView.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/10.
//

import UIKit

final class TitleStackView: UIStackView {

    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    func configureContent(iconData: Data?, date: String?) {
        configureUI()
        
        guard let data = iconData else { return }
        weatherIcon.image = UIImage(data: data)
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
