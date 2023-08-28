//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/28.
//

import UIKit

    static let identifier = "cell"
    
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        
        return stackView
    }()
    
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.text = "제목입니다. 제목입니다. 제목입니다. 제목입니다. 제목입니다. 제목입니다."
        
        return label
    }()
    
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "2023년 08월 28일"
        
        return label
    }()
    
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "안녕하세요? 민트와 비모입니다. 안녕하세요? 민트와 비모입니다. 안녕하세요? 민트와 비모입니다. 안녕하세요? 민트와 비모입니다."
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        configureCellSubviews()
        configureCellConstraint()
    }
    
    private func configureCellSubviews() {
        contentView.addSubview(contentStackView)
        descriptionStackView.addArrangedSubview(date)
        descriptionStackView.addArrangedSubview(preview)
        contentStackView.addArrangedSubview(title)
        contentStackView.addArrangedSubview(descriptionStackView)
    }
    
    private func configureCellConstraint() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
