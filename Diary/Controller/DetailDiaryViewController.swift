//
//  Diary - DetailDiaryViewController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class DetailDiaryViewController: UIViewController {
    private var diaryDate: String?
    private let coreDataManager = CoreDataManager.shared
    private let locationDataManager = LocationDataManager.shared
    private let server = NetworkManager.shared
    private let decodeManager = DecodeManager.shared
    private let urlRequestMaker = URLRequestMaker()
    private let isDiaryCreated: Bool
    private var isSaveRequired: Bool
    private var diary: Diary?
    private var latitude: String?
    private var longitude: String?
    private var iconName: String?
    private let diaryListView = DiaryListViewController()
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = NameSpace.diaryPlaceholder
        textView.keyboardDismissMode = .interactive
        
        return textView
    }()
    
    init(isCreateDiary: Bool, isSaveRequired: Bool) {
        self.isDiaryCreated = isCreateDiary
        self.isSaveRequired = isSaveRequired
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        configureSubview()
        configureConstraint()
        configureKeyboard()
        addDeactiveNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDiary()
    }
    
    func configureContent(diary: Diary) {
        self.diary = diary
        diaryTextView.text = diary.title + NameSpace.newline + diary.body
        diaryTextView.contentOffset = CGPoint.zero
        diaryDate = Date(timeIntervalSince1970: diary.date).convertDate()
        title = diaryDate
    }
    
    // MARK: - configure method
    private func configureSubview() {
        view.addSubview(diaryTextView)
    }
    
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        diaryTextView.delegate = self
        diaryTextView.setContentOffset(.zero, animated: true)
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showDetailAction))
        
        if diaryDate == nil {
            title = Date().convertDate()
        }
    }
    
    private func configureKeyboard() {
        if isDiaryCreated {
            diaryTextView.becomeFirstResponder()
        }
    }
    
    private func configureLocation() {
        guard let latitudeData = locationDataManager.fetchLocation()?.latitude,
              let longitudeData = locationDataManager.fetchLocation()?.longitude else { return }
        
        latitude = String(format: "%.2f", latitudeData)
        longitude = String(format: "%.2f", longitudeData)
    }
    
    // MARK: - Notification method
    private func addDeactiveNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterTaskSwitcher),
                                               name: UIScene.willDeactivateNotification,
                                               object: nil)
    }
    
    @objc
    private func enterTaskSwitcher() {
        saveDiary()
    }
    
    // MARK: - Action Sheet method
    @objc
    private func showDetailAction() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let share = UIAlertAction(title: NameSpace.share, style: .default) { _ in
            self.saveDiary()
            guard let diary = self.diary else { return }
            ActionController.showActivityViewController(from: self,
                                                        title: diary.title,
                                                        body: diary.body)
        }
        
        let delete = UIAlertAction(title: NameSpace.delete, style: .destructive) { _ in
            self.showDeleteAlert()
        }
        
        let cancel = UIAlertAction(title: NameSpace.cancel, style: .cancel)
        
        actionSheet.addAction(share)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true)
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: NameSpace.alertTitle,
                                      message: NameSpace.alertMessage,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: NameSpace.cancel, style: .cancel)
        let delete = UIAlertAction(title: NameSpace.delete, style: .destructive) { _ in
            self.deleteDiary()
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true)
    }
    
    // MARK: - CoreData method
    private func saveDiary() {
        configureLocation()
        
        fetchWeatherData() {
            DispatchQueue.main.async {
                if self.isSaveRequired {
                    if self.isDiaryCreated {
                        self.createDiary()
                    } else {
                        self.updateDiary()
                    }
                }
                self.isSaveRequired = false
            }
        }
    }
    
    private func createDiary() {
        let diaryContents = diaryTextView.text.split(separator: "\n", maxSplits: 1)
        
        guard diaryContents.count != 0,
              let date = Date().timeIntervalSince1970.roundDownNumber() else { return }
        
        let id = UUID()
        let title = String(diaryContents[0])
        let body = validBody(diaryContents)
        
        coreDataManager.createDiary(Diary(id: id, title: title, body: body, date: date, iconName: self.iconName))
    }
    
    private func updateDiary() {
        let diaryContents = diaryTextView.text.split(separator: "\n", maxSplits: 1)
        
        guard diaryContents.count != 0 else {
            deleteDiary()
            
            return
        }
        
        let title = String(diaryContents[0])
        let body = validBody(diaryContents)
        
        guard let id = diary?.id,
              let date = Date().timeIntervalSince1970.roundDownNumber() else { return }
        
        coreDataManager.updateDiary(diary: Diary(id: id, title: title, body: body, date: date, iconName: self.iconName))
    }
    
    private func deleteDiary() {
        guard let diary else { return }
        
        do {
            try self.coreDataManager.deleteDiary(diary: diary)
        } catch {
            let alert = UIAlertController(title: "알림", message: "\(error)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        isSaveRequired = false
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func validBody(_ string: [String.SubSequence]) -> String {
        var result: String = NameSpace.empty
        
        if string.count == 2 {
            result = String(string[1])
        }
        
        return result
    }
    
    // MARK: -
    private func fetchWeatherData(completion: @escaping () -> Void) {
        guard let latitude, let longitude,
              let request = urlRequestMaker.request(latitude: latitude, longitude: longitude) else { return }
        
        server.startLoad(request: request) { result in
            do {
                guard let verifiedFetchingResult = try self.verifyResult(result: result) else { return }
                
                let decodedFile = self.decodeManager.decodeJSON(data: verifiedFetchingResult, type: WeatherInformation.self)
                
                guard let verifiedDecodingResult = try self.verifyResult(result: decodedFile) else { return }
                
                self.iconName = verifiedDecodingResult.weather[0].icon
                completion()
            } catch {
                print(error)
            }
        }
    }
    
    private func verifyResult<T, E: Error>(result: Result<T, E>) throws -> T? {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}

extension DetailDiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveDiary()
    }
}

private enum NameSpace {
    static let diaryPlaceholder = "내용을 입력하세요"
    static let newline = "\n"
    static let empty = ""
    static let share = "공유"
    static let cancel = "취소"
    static let delete = "삭제"
    static let alertTitle = "진짜요?"
    static let alertMessage = "정말로 삭제하시겠어요?"
}
