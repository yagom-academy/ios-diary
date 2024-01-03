//
//  DiaryListCell.swift
//  Diary
//
//  Created by 김우현 on 1/3/24.
//

import UIKit

class DiaryListCell: UITableViewCell {

    static let identifier = "DiaryListCell"
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 2
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    private func setupLabel() {
//        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    private func setupStackView() {
        stackView.addSubview(dateLabel)
        stackView.addSubview(previewLabel)
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
