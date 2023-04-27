//
//  AlertViewData.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

struct AlertViewData {
    let title: String
    let message: String
    let style: UIAlertController.Style
    let enableOkAction: Bool
    let okActionTitle: String
    let okActionStyle: UIAlertAction.Style
    let enableCancelAction: Bool
    let cancelActionTitle: String
    let cancelActionStyle: UIAlertAction.Style
    let completion: (() -> Void)?
    
    init(title: String,
         message: String,
         style: UIAlertController.Style,
         enableOkAction: Bool,
         okActionTitle: String,
         okActionStyle: UIAlertAction.Style = .default,
         enableCancelAction: Bool,
         cancelActionTitle: String,
         cancelActionStyle: UIAlertAction.Style = .cancel,
         completion: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.style = style
        self.enableOkAction = enableOkAction
        self.okActionTitle = okActionTitle
        self.okActionStyle = okActionStyle
        self.enableCancelAction = enableCancelAction
        self.cancelActionTitle = cancelActionTitle
        self.cancelActionStyle = cancelActionStyle
        self.completion = completion
    }
}
