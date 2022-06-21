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
    var diary: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    private func setInitialView() {
        self.view = diaryView
        NotificationCenter.default.addObserver(self, selector: #selector(saveDiary), name: Notification.Name.sceneDidEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveDiary), name: UIResponder.keyboardWillHideNotification, object: nil)
        configureOptionButton()
    }
    
    private func configureOptionButton() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(touchOptionButton))
        
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    private func update(_ testData: Diary?) {
        do {
            guard let testData = testData else {
                return
            }

            try CoreDataManager.shared.update(testData)
        } catch {
            print("저장에 실패했습니다")
        }
    }
    
    private func diaryText() -> [String] {
        let textArray = diaryView.diaryTextView.text.components(separatedBy: "\n")
        return textArray
    }
    
    private func touchShareButton() {
        let text = [diaryText().joined(separator: "\n")]
        let share = UIActivityViewController(activityItems: text, applicationActivities: nil)
        self.present(share, animated: true)
    }
    
    private func touchDeleteButton() {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            guard let diary = self.diary else {
                return
            }
            
            do {
                try CoreDataManager.shared.delete(diary)
                self.delegate?.updateView()
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("삭제에 실패했습니다")
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func touchOptionButton() {
        diaryView.diaryTextView.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            self.touchShareButton()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.touchDeleteButton()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func saveDiary() {
        var textArray = diaryText()
        if diary == nil {
            diary = Diary(title: textArray.removeFirst(), body: textArray.joined(separator: "\n"), createdAt: Date().timeIntervalSince1970, id: UUID())
        } else {
            diary?.title = textArray.removeFirst()
            diary?.body = textArray.joined(separator: "\n")
        }
        update(diary)
        delegate?.updateView()
    }
}
