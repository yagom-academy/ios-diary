//
//  DiaryViewController.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/14.
//

import UIKit

class DiaryViewController: UIViewController {
    lazy var diaryView = DiaryView.init(frame: view.bounds)
    weak var delegate: DataSendable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        update()
    }
    
    private func update() {
        do {
            try CoreDataManager.shared.update(setTestData())
        } catch {
            print("저장에 실패했습니다")
        }
    }
    
    private func setTestData() -> TestData {
        var textArray = diaryView.diaryTextView.text.components(separatedBy: "\n")
        return TestData(title: textArray.removeFirst(), body: textArray.joined(separator: "\n"), createdAt: Date().timeIntervalSince1970, id: UUID())
    }
    
    private func setInitialView() {
        self.view = diaryView
    }
}
