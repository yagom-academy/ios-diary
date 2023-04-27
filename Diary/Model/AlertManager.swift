//
//  AlertManager.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/26.
//

import UIKit

struct AlertManager {
    func showErrorAlert(target: UIViewController, error: CustomStringConvertible) {
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        target.present(alert, animated: true)
    }
}
