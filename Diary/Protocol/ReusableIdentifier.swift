//
//  ReusableIdentifier.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/28.
//

import UIKit

public protocol ReusableIdentifier: AnyObject {
    static var identifier: String { get }
}

public extension ReusableIdentifier where Self: UIView {
    static var identifier: String { return String(describing: self) }
}

extension UITableViewCell: ReusableIdentifier { }


