//
//  Diary - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DiaryListViewController: UIViewController {

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootViewUI()
    }
}

// MARK: - Private Methods

private extension DiaryListViewController {

    func configureRootViewUI() {
        view.backgroundColor = .white

        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(rightBarButtonDidTap)
        )
    }
    
    @objc func rightBarButtonDidTap() {
        let diaryDetailViewController = DiaryDetailViewController()
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}
