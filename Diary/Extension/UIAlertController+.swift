//
//  UIAlertController+.swift
//  Diary
//
//  Created by JPush, Wonbi on 2023/01/06.
//

import UIKit

extension UIAlertController {
    enum AlertMessage {
        case share
        case delete
        case cancel
        case ellipsis
        case deleteTitle
        case deleteMessage
        
        var description: String {
            switch self {
            case .share:
                return "Share"
            case .delete:
                return "Delete"
            case .cancel:
                return "Cancel"
            case .ellipsis:
                return "..."
            case .deleteTitle:
                return "Really?"
            case .deleteMessage:
                return "Are you sure want to delete?"
            }
        }
    }
    
    static func alertMessage(key: AlertMessage, withEllipsis: Bool = false) -> String {
        if withEllipsis {
            return key.description.localized + AlertMessage.ellipsis.description
        } else {
            return key.description.localized
        }
    }
}
