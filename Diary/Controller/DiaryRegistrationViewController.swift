//
//  DiaryRegistrationViewController.swift
//  Diary
//
//  Created by Mangdi on 2022/12/22.
//

import UIKit

class DiaryRegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationItem()
    }

    private func configureNavigationItem() {
        let timeInterval = Date().timeIntervalSince1970
        navigationItem.title = DateFormatter.convertToCurrentLocalizedText(timeIntervalSince1970: timeInterval)
    }
}
