//
//  DetailViewController.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import UIKit

class DetailViewController: UIViewController {
    private var sampleData: DiaryModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    init(sampleData: DiaryModel? = nil) {
        self.sampleData = sampleData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
