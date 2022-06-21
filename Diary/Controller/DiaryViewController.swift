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
    
    func update(_ testData: Diary?) {
        do {
            guard let testData = testData else {
                return
            }

            try CoreDataManager.shared.update(testData)
        } catch {
            print("저장에 실패했습니다")
        }
    }
    
    private func setInitialView() {
        self.view = diaryView
        self.navigationItem.setRightBarButton(optionButton(), animated: true)
    }
    
    private func optionButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showMenu))
        
        return barButton
    }
    
    @objc private func touchOptionButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            print("공유하기")
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            print("삭제하기")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
