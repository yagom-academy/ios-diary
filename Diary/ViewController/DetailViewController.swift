//
//  DetailViewController.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

final class DetailViewController: UIViewController {
    private var detailView = DetailView()
    private var diaryData: DiaryData
    
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(diary: DiaryData) {
        diaryData = diary
        detailView.setData(with: diaryData)
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = diaryData.date.toString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
