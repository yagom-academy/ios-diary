//
//  DetailViewController.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

protocol DetailViewable: UIView {
    func setData(with diary: DiaryInfo)
    func changeTextViewHeight(_ height: CGFloat)
    func exportDiaryText() -> DiaryInfo
}

final class DetailViewController: UIViewController {
    private enum State {
        case update
        case delete
    }
    
    private var detailView: DetailViewable
    private var diaryData: DiaryInfo?
    private var viewModel: TableViewModel<DiaryUseCase>
    private var state: State = .update
     
    init(view: DetailViewable, viewModel: TableViewModel<DiaryUseCase>) {
        self.detailView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = diaryData?.date?.toString
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark.circle")
        
        if let icon = diaryData?.icon {
            imageView.weatherImage(icon: icon)
        }
        return imageView
    }()
    
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #unavailable(iOS 15.0) {
            registerForKeyboardNotification()
            setViewGesture()
        }
        setNavigationSetting()
        (UIApplication.shared.delegate as? AppDelegate)?.saveDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (UIApplication.shared.delegate as? AppDelegate)?.saveDelegate = nil
        saveData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeRegisterForKeyboardNotification()
    }
    
    func updateData(diary: DiaryInfo) {
        diaryData = diary
        detailView.setData(with: diary)
    }
    
    private func saveData() {
        if state == .update {
            let editedDiary = detailView.exportDiaryText()
            viewModel.update(data: editedDiary) { error in
                self.alertMaker.makeErrorAlert(error: error)
            }
        }
    }
}

// MARK: - Keyboard Method

extension DetailViewController {
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
     }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDownAction))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyBoardShow(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary else {
            return
        }
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyBoardSize = keyboardRectangle.height
        detailView.changeTextViewHeight(keyBoardSize)
    }
    
    @objc func keyboardDownAction(_ sender: UISwipeGestureRecognizer) {
        self.view.endEditing(true)
        detailView.changeTextViewHeight(0)
        saveData()
    }
}

// MARK: Navigation Method
extension DetailViewController {
    private func setNavigationSetting() {
        let stackView = UIStackView(arrangedSubviews: [titleImageView, titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill

        navigationItem.titleView = stackView

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(rightBarbuttonClicked(_:))
        )
    }
    
    func updateNavigationImage(with diaryInfo: DiaryInfo) {
        guard let icon = diaryInfo.icon else {
            return
        }
        titleImageView.weatherImage(icon: icon)
    }
    
    @objc private func rightBarbuttonClicked(_ sender: Any) {
        guard let diaryData = diaryData else { return }
        
        let shareButtonHandler: (UIAlertAction) -> Void = { _ in
            let diaryInfo = self.detailView.exportDiaryText()
            let activityController = UIActivityViewController(
                activityItems: [diaryInfo.body ?? ""],
                applicationActivities: nil)
            self.present(activityController, animated: true)
        }
        
        let deleteButtonHandler: (UIAlertAction) -> Void = { _ in
            let cancleButton = UIAlertAction(title: "취소", style: .cancel)
            let deleteButton = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.state = .delete
                    self.viewModel.delete(data: diaryData) { error in
                        self.alertMaker.makeErrorAlert(error: error)
                    }
                self.navigationController?.popViewController(animated: true)
            }
            self.alertMaker.makeAlert(title: "진짜요?",
                                      message: "정말로 삭제하시겠어요?",
                                      buttons: [cancleButton, deleteButton])
        }

        alertMaker.makeActionSheet(buttons: [UIAlertAction(title: "Share",
                                                           style: .default,
                                                           handler: shareButtonHandler),
                                             UIAlertAction(title: "Delete",
                                                           style: .destructive,
                                                           handler: deleteButtonHandler)])
    }
}

extension DetailViewController: SaveDelegate {
    func save() {
        saveData()
    }
}
