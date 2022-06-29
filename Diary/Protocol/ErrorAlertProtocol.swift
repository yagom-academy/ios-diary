//
//  ErrorAlertProtocol.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/28.
//

import UIKit

protocol ErrorAlertProtocol: UIViewController {}

extension ErrorAlertProtocol {
    func showAlert(alertMessage: String) {
        let alert = UIAlertController(
            title: "Error",
            message: alertMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        )
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
