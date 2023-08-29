//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/29.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private var diaryEntity: [DiaryEntity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(data: [DiaryEntity]) {
        self.diaryEntity = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
