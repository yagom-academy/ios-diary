//
//  DiaryContentConfiguration.swift
//  Diary
//
//  Created by hamo and mini on 2022/12/20.
//

import UIKit

struct DiaryContentConfiguration: UIContentConfiguration, Hashable {
    var headerString: String?
    var dateString: String?
    var bodyString: String?
    
    func makeContentView() -> UIView & UIContentView {
        return DiaryContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}

class DiaryContentView: UIView, UIContentView {
    let headerLabel = UILabel()
    let dateLabel = UILabel()
    let bodyLabel = UILabel()
    private var appliedConfiguration: DiaryContentConfiguration?
    
    init(configuration: DiaryContentConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        get {
            return appliedConfiguration ?? DiaryContentConfiguration()
        }
        set {
            guard let newConfig = newValue as? DiaryContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private func setupInternalViews() {
        let insideStackView = UIStackView(arrangedSubviews: [dateLabel, bodyLabel])
        insideStackView.distribution = .fillEqually
        
        let totalStackView = UIStackView(arrangedSubviews: [headerLabel, insideStackView])
        totalStackView.axis = .vertical
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(totalStackView)
        
        layoutMargins.left += 10
        
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            totalStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func apply(configuration: DiaryContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        headerLabel.text = configuration.headerString
        dateLabel.text = configuration.dateString
        bodyLabel.text = configuration.bodyString
    }
}
