//
//  DiaryListViewController.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/17.
//

import UIKit

final class DiaryListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        configureNavigationBarItems()
    }

    private func configureNavigationBarItems() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(tappedPlusButton))

        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationItem.title = "일기장"
    }

    @objc private func tappedPlusButton() {
        print("+ 버튼이 눌렸습니다.")
    }
}
