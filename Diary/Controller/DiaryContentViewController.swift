//
//  DiaryContentViewController.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/26.
//

import UIKit

final class DiaryContentViewController: UIViewController {
    private let diary: DiarySample?
    
    init(diary: DiarySample? = nil) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRootView()
        setUpNavigationBar()
    }
    
    private func setUpRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setUpNavigationBar() {
        let timeInterval = diary?.createdDate ?? Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timeInterval)
        
        navigationItem.title = DateFormatter.diaryForm.localizeDateString(from: date)
    }
}
