//
//  CellMakeable.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

protocol CellMakeable {
    var titleLabel: UILabel { get }
    var dateLabel: UILabel { get }
    var descriptionLabel: UILabel { get }
    
    func createLabel(
        font: UIFont,
        textColor: UIColor,
        alignment: NSTextAlignment
    ) -> UILabel
    
    func createStackView(
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment,
        distribution: UIStackView.Distribution,
        spacing: CGFloat
    ) -> UIStackView
}

extension CellMakeable {
    func createLabel(
        font: UIFont,
        textColor: UIColor,
        alignment: NSTextAlignment
    ) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.textAlignment = alignment
        return label
    }
    
    func createStackView(
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment,
        distribution: UIStackView.Distribution,
        spacing: CGFloat
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
}
