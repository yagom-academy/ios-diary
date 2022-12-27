//
//  EditDiaryViewController.swift
//  Diary
//
//  Created by jin on 12/27/22.
//

import UIKit

final class EditDiaryViewController: DiaryItemViewController {

    init(diary: Diary?) {
        super.init(nibName: nil, bundle: nil)
        self.diary = diary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTexts()
        configureNavigationItem()
    }
    
    func updateTexts() {
        updateTitleText(title: diary?.title)
        updateContentText(content: diary?.content)
    }
    
    func configureNavigationItem() {
        guard let timeInterval = diary?.createdAt else { return }
        let currentDate = DateFormatter.conversionLocalDate(date: Date(timeIntervalSince1970: timeInterval), locale: .current, dateStyle: .long)
        self.navigationItem.title = currentDate
    }
}
