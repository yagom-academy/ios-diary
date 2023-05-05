//
//  IdentifierType.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/24.
//

import UIKit

public protocol IdentifierType {
    static var identifier: String { get }
}

extension IdentifierType {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: IdentifierType { }
extension UITableViewCell: IdentifierType { }
