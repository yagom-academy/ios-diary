//
//  DiaryContentView.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.
        

import UIKit

final class DiaryListCellContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        get {
            return appliedConfiguration ?? DiaryContentConfiguration()
        }
        set {
            guard let newConfig = newValue as? DiaryContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private let headerLabel = UILabel()
    private let dateLabel = UILabel()
    private let bodyLabel = UILabel()
    private let weatherImageView = UIImageView()
    private var appliedConfiguration: DiaryContentConfiguration?
    
    init(configuration: DiaryContentConfiguration) {
        super.init(frame: .zero)
        configureDynamicFont()
        setupSubviews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(configuration: DiaryContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        headerLabel.text = configuration.headerString
        dateLabel.text = configuration.dateString
        bodyLabel.text = configuration.bodyString
        
        guard let imageEndpoint = ImageLoadAPI(icon: configuration.iconName) else { return }
        
        ImageLoader().loadImage(endPoint: imageEndpoint) { image in
            DispatchQueue.main.async {
                self.weatherImageView.image = image
            }
        }
    }
}

// MARK: UI Configuration
extension DiaryListCellContentView {
    private func defaultContentStackView() -> UIStackView {
        let insideStackView = UIStackView(arrangedSubviews: [dateLabel, weatherImageView, bodyLabel])
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        insideStackView.alignment = .leading
        insideStackView.distribution = .fill
        insideStackView.spacing = 8
        bodyLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let totalStackView = UIStackView(arrangedSubviews: [headerLabel, insideStackView])

        totalStackView.axis = .vertical
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return totalStackView
    }
    
    private func configureDynamicFont() {
        headerLabel.font = .preferredFont(forTextStyle: .title3)
        headerLabel.adjustsFontForContentSizeCategory = true
        
        [dateLabel, bodyLabel].forEach {
            $0.font = .preferredFont(forTextStyle: .body)
            $0.adjustsFontForContentSizeCategory = true
        }
    }
    
    private func setupSubviews() {
        let contentStackView = defaultContentStackView()
        
        addSubview(contentStackView)
        
        layoutMargins.left += 10
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            contentStackView
                .bottomAnchor
                .constraint(greaterThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
            
            weatherImageView.heightAnchor.constraint(equalToConstant: 20),
            weatherImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
