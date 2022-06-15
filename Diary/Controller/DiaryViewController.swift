//
//  DiaryViewController.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/14.
//

import UIKit

final class DiaryViewController: UIViewController {
    private lazy var diaryView = DiaryView.init(frame: view.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryView
    }
}
