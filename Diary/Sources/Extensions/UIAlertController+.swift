//
//  UIAlertController+.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

extension UIAlertController {
    convenience init(
        title: String? = nil,
        message: String? = nil,
        diary: Diary,
        deleteCompletion: ((UIAlertAction) -> Void)? = nil,
        cancelCompletion: ((UIAlertAction) -> Void)? = nil
    ) {
        self.init(title: title, message: message, preferredStyle: .alert)
        
        let cancelTitle = LocalizedConstant.AlertTitles.cancelTitle
        let deleteTitle = LocalizedConstant.AlertTitles.deleteTitle
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancelCompletion)
        let deleteAction = UIAlertAction(
            title: deleteTitle,
            style: .destructive,
            handler: deleteCompletion
        )
        
        self.addAction(cancelAction)
        self.addAction(deleteAction)
    }
}
