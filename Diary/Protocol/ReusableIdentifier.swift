//
//  ReusableIdentifier.swift
//  Diary
//
//  Created by Seoyeon Hong on 2023/04/26.
//

import UIKit

protocol ReusableIdentifier {
    static var identifier: String { get }
}

extension ReusableIdentifier where Self: UIView {
    static var identifier: String { return String(describing: self) }
}

extension UITableViewCell: ReusableIdentifier {}
