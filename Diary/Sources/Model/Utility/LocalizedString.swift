//
//  LocalizedString.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

enum LocalizedConstant {
    enum App {
        static let appTitle = NSLocalizedString("AppTitle", comment: "앱 타이틀")
    }
    
    enum AlertTitles {
        static let shareTitle = NSLocalizedString("Share", comment: "공유 제목")
        static let cancelTitle = NSLocalizedString("Cancel", comment: "취소 제목")
        static let deleteTitle = NSLocalizedString("Delete", comment: "삭제 제목")
        
        static func localized(type: UIAlertAction.ButtonStyle) -> String {
            switch type {
            case .share:
                return shareTitle
            case .cancel:
                return cancelTitle
            case .delete:
                return deleteTitle
            }
        }
    }
    
    enum AlertController {
        static let deleteTitle = NSLocalizedString("DeleteTitle", comment: "삭제 Alert 제목")
        static let deleteMessage = NSLocalizedString("DeleteMessage", comment: "삭제 Alert 본문")
    }
}
