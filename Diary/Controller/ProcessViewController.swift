//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/25.
//
import UIKit
import CoreLocation

final class ProcessViewController: UIViewController {
    private enum LocalizationText {
        case delete, share, cancel, deleteAlertTitle, deleteAlertMessage
        
        func localizd() -> String {
            switch self {
            case .delete:
                return "삭제".localized()
            case .share:
                return "공유".localized()
            case .cancel:
                return "취소".localized()
            case .deleteAlertTitle:
                return "진짜요?".localized()
            case .deleteAlertMessage:
                return "정말로 삭제하시겠어요?".localized()
            }
        }
    }
    
    private typealias DiaryInformation = (title: String, body: String)
    private let diaryTextView = UITextView()
    private var diary: Diary?
    private var isDeleteDiary: Bool = false
    private let diaryService: DiaryService
    private let locationDataManager = LocationDataManager()
    
    init(diary: Diary? = nil, diaryService: DiaryService) {
        self.diary = diary
        self.diaryService = diaryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureDiaryTextView()
        setUpNotification()
//        setDiaryWeatherInformation(coordinate: )
    }
    
    func setDiaryWeatherInformation(coordinate: CLLocationCoordinate2D) {
        let weatherService = DefaultWeatherService()
        weatherService.fetchWeatherInformation(latitude: coordinate.latitude, longtitude: coordinate.longitude) { result in
            switch result {
            case .success(let info):
                print(info)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        diaryTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        autoSave()
    }
    
    private func configureNavigationItem() {
        let localizedDateFormatter = DateFormatter(
            languageIdentifier: Locale.preferredLanguages.first ?? Locale.current.identifier
        )
        navigationItem.title = localizedDateFormatter.string(from: Date())
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(didTapMoreButton)
        )
    }
    
    private func configureDiaryTextView() {
        if diary != nil {
            updateTextView(diary: diary)
        }
        
        view.addSubview(diaryTextView)
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        diaryTextView.font = .preferredFont(forTextStyle: .body)
        diaryTextView.adjustsFontForContentSizeCategory = true
        diaryTextView.contentOffset = .zero
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateTextView(diary: Diary?) {
        guard let diary else {
            return
        }
        diaryTextView.text = "\(diary.title)\n\(diary.body)"
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(autoSave),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc private func autoSave() {
        let diaryInformation = currentDiaryInformation()
        processDiary(diaryInformation)
    }
    
    private func currentDiaryInformation() -> DiaryInformation? {
        guard let text = diaryTextView.text else {
            return nil
        }
        
        guard let firstIndex = text.firstIndex(of: "\n") else {
            return (title: text, body: "")
        }
        
        let secondIndex = text.index(after: firstIndex)
        let title = String(text[text.startIndex..<firstIndex])
        let body = String(text[secondIndex...])
        
        return (title: title, body: body)
    }
    
    private func processDiary(_ diaryInformation: DiaryInformation?) {
        guard let diaryInformation else {
            return
        }
        
        if isDeleteDiary {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if let diary {
            diaryService.update(id: diary.id, title: diaryInformation.title, body: diaryInformation.body)
        } else {
            let result = diaryService.create(id: UUID(), title: diaryInformation.title, body: diaryInformation.body)
            
            if case .success(let newDiary) = result {
                diary = newDiary
            }
        }
    }
    
    @objc private func didTapMoreButton() {
        diaryTextView.resignFirstResponder()
        autoSave()
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: LocalizationText.share.localizd(), style: .default, handler: { [weak self] _ in
            var objectsToShare = [String]()
            if let text = self?.diaryTextView.text {
                objectsToShare.append(text)
            }
            
            let activityViewController = UIActivityViewController(
                activityItems: objectsToShare,
                applicationActivities: nil
            )
            
            self?.present(activityViewController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: LocalizationText.delete.localizd(), style: .destructive, handler: { _ in
            self.presentDeleteAlert()
        }))
        
        actionSheet.addAction(UIAlertAction(title: LocalizationText.cancel.localizd(), style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func presentDeleteAlert() {
        let deleteAlertController = UIAlertController(
            title: LocalizationText.deleteAlertTitle.localizd(),
            message: LocalizationText.deleteAlertMessage.localizd(),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: LocalizationText.cancel.localizd(),
            style: .default
        )
        
        let deleteAction = UIAlertAction(
            title: LocalizationText.delete.localizd(),
            style: .destructive) { [weak self] _ in
                guard let diary = self?.diary else {
                    return
                }
                
                self?.diaryService.delete(id: diary.id)
                self?.isDeleteDiary = true
                self?.navigationController?.popViewController(animated: true)
            }
        
        deleteAlertController.addAction(cancelAction)
        deleteAlertController.addAction(deleteAction)
        
        self.present(deleteAlertController, animated: true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = diaryTextView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        diaryTextView.contentInset = contentInset
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        diaryTextView.contentInset = UIEdgeInsets.zero
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
}

extension ProcessViewController: SettingAlertPresentable {
    func presentSystemSettingAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
}
