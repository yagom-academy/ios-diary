//
//  UIAlertController+.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/09/01.
//

import UIKit

extension UIAlertController {
    static func customAlert(
        alertTile: String?,
        alertMessage: String?,
        preferredStyle: UIAlertController.Style,
        alertActions: [UIAlertAction]
    ) -> UIAlertController {
        let alert = UIAlertController(title: alertTile, message: alertMessage, preferredStyle: preferredStyle)
        
        alertActions.forEach {
            alert.addAction($0)
        }

        return alert
    }
}
