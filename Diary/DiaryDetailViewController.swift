//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/14.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let mainView = DiaryDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainView)
    }
}
