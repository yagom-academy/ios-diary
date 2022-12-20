//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private lazy var addDiaryButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add,
                                     target: self,
                                     action: #selector(addDiary))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
    }
}

extension DiaryListViewController {
    @objc private func addDiary() {
        print("tapped addDiaryButton")
    }

    private func configureNavigation() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = addDiaryButton
    }
}
