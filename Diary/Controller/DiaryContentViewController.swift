//
//  DiaryContentViewController.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/26.
//

import UIKit
import CoreLocation

final class DiaryContentViewController: UIViewController {
    typealias DiaryText = (title: String?, body: String?)
    
    private var diary: Diary?
    private let textView = UITextView()
    private let alertFactory: DiaryAlertFactory = DiaryAlertMaker()
    private let alertDataMaker: DiaryAlertDataFactory = DiaryAlertDataMaker()
    private let diaryDataManager = DiaryDataManager()
    private let locationManager = CLLocationManager()
    private let weatherDataLoader = OpenWetherDataLoader()

    init(diary: Diary? = nil) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLocationManager()
        setUpRootView()
        setUpNavigationBar()
        setUpTextView()
        addObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showKeyboardIfNeeded()
        createDiaryIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateDiary()
    }
    
    func updateDiary() {
        guard let diary else { return }
        
        let currentContents: DiaryText = devideTitleAndBody(text: textView.text)
        let updatedDate = Date().timeIntervalSince1970
        
        if isDiaryEdited(currentContents) {
            diary.updateContents(title: currentContents.title,
                                 body: currentContents.body,
                                 updatedDate: updatedDate)
            diaryDataManager.update(data: diary)
        }
    }
    
    private func setUpLocationManager() {
        locationManager.delegate = self
    }
    
    private func isDiaryEdited(_ currentContents: DiaryText) -> Bool {
        guard let diary else { return false }
        
        if diary.title != currentContents.title || diary.body != currentContents.body {
            return true
        } else {
            return false
        }
    }
    
    private func devideTitleAndBody(text: String?) -> DiaryText {
        guard let text,
              let newLineIndex = text.firstIndex(of: "\n") else { return (text, nil) }
        
        let startIndex = text.startIndex
        let titleRange = startIndex..<newLineIndex
        let bodyRange = newLineIndex...
        let title = String(text[titleRange])
        let body = String(text[bodyRange])
        
        return (title, body)
    }
    
    private func setUpRootView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
    }
    
    private func setUpNavigationBar() {
        if let diary {
            navigationItem.title = diary.updatedDateText
        } else {
            let timeInterval = Date().timeIntervalSince1970
            let date = Date(timeIntervalSince1970: timeInterval)
            
            navigationItem.title = DateFormatter.diaryForm.string(from: date)
        }
        
        let image = UIImage(systemName: "ellipsis.circle")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tapEllipsisButton))
    }
    
    @objc
    private func tapEllipsisButton() {
        presentActionSheet()
    }
    
    private func setUpTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        
        setUpTextViewLayout()
        configureTextViewContent()
    }
    
    private func setUpTextViewLayout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            textView.topAnchor.constraint(equalTo: safe.topAnchor),
            textView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    private func configureTextViewContent() {
        guard let diary = diary else { return }
        
        if let title = diary.title, let body = diary.body {
            textView.text = title + body
        } else {
            textView.text = diary.title
        }
        
    }
    
    private func showKeyboardIfNeeded() {
        if diary == nil {
            textView.becomeFirstResponder()
        }
    }
    
    private func createDiaryIfNeeded() {
        if diary == nil {
            let createdDate = Date().timeIntervalSince1970
            
            self.diary = Diary(title: "", body: "", updatedDate: createdDate)
            self.diary?.weather = Weather()
            
            guard let diary else { return }
            
            diaryDataManager.create(data: diary)
        }
    }
}

// MARK: - KeyboardNotification
extension DiaryContentViewController {
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(noti:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardWillShow(noti: NSNotification) {
        guard let keyboardSize = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        textView.contentInset.bottom = keyboardHeight
        textView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc
    private func keyboardWillHide() {
        textView.contentInset.bottom = .zero
        textView.verticalScrollIndicatorInsets.bottom = .zero
        
        updateDiary()
    }
}

// MARK: - Present View
extension DiaryContentViewController {
    private func presentActionSheet() {
        let alertData = alertDataMaker.actionSheetData { [weak self] in
            guard let self = self else { return }
            
            self.presentActivityView()
        } deleteCompletion: { [weak self] in
            guard let self else { return }
            
            self.presentDeleteAlert()
        }
        let alert = alertFactory.actionSheet(for: alertData)

        present(alert, animated: true)
    }
    
    private func presentActivityView() {
        guard let text = textView.text else { return }
        
        let activityView = UIActivityViewController(activityItems: [text],
                                                    applicationActivities: nil)
        
        present(activityView, animated: true)
    }
    
    private func presentDeleteAlert() {
        let alertData = alertDataMaker.deleteAlertData { [weak self] in
            guard let self, let id = self.diary?.id else { return }
            
            self.diaryDataManager.delete(id: id)
            self.diary = nil
            self.navigationController?.popViewController(animated: true)
        }
        let alert = alertFactory.deleteDiaryAlert(for: alertData)
        
        present(alert, animated: true)
    }
}

// MARK: - Location
extension DiaryContentViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            weatherDataLoader.loadData(latitude: coordinate.latitude,
                                       longitude: coordinate.longitude) { result in
                switch result {
                case .success(let currentWeather):
                    guard let weather = currentWeather.weather.first else { return }
                    
                    self.diary?.weather?.updateContents(main: weather.main, icon: weather.icon)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
