//  Diary - DiaryViewController.swift
//  Created by Ayaan, zhilly on 2022/12/20

import UIKit

final class DiaryViewController: UIViewController {
    private let diaryTitle: String = "일기장"

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        title = diaryTitle
    }
}
