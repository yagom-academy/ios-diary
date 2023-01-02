//
//  UIAlertAction+.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

extension UIAlertAction {
    typealias Handler = (UIAlertAction) -> Void
    
    enum ButtonStyle: String {
        case share = "Share"
        case delete = "Delete"
        case cancel = "Cancel"
        
        var style: UIAlertAction.Style {
            switch self {
            case .share:
                return .`default`
            case .delete:
                return .destructive
            case .cancel:
                return .cancel
            }
        }
        
        var title: String {
            return String(LocalizedConstant.AlertTitles.localized(type: self))
        }
    }
    
    convenience init(type: ButtonStyle, handler: Handler? = nil) {
        self.init(title: type.title, style: type.style, handler: handler)
    }
}
