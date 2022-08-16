//
//  DiaryContentsViewController.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import UIKit

class DiaryContentsViewController: UIViewController {
    
    // MARK: Life Cycle
    
    override func loadView() {
        view = DiaryContentView()
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Date().formatToStringDate()
