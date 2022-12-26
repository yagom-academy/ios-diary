//
//  NewDiaryViewController.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/21.
//

import UIKit

final class NewDiaryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    private func configureView() {
        view.backgroundColor = .systemYellow
        configureNavigationBar()
    }

    private lazy var cancelAction = UIAction { _ in
        self.dismiss(animated: true)
    }

    private func configureNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "취소", primaryAction: cancelAction)

        navigationItem.title = Date().localeFormattedText
        navigationItem.leftBarButtonItem = cancelButton
    }
}
