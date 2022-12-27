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
        
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: cancelCompletion)
        let deleteAction = UIAlertAction(
            title: "삭제",
            style: .destructive,
            handler: deleteCompletion
        )
        
        self.addAction(cancelAction)
        self.addAction(deleteAction)
    }
}
