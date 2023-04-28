//
//  IdentifierType.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/24.
//

import UIKit

public protocol IdentifierType { }

extension IdentifierType {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: IdentifierType { }
