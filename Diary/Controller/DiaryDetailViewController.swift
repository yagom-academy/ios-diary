//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/25.
//

import UIKit
import CoreLocation

final class DiaryDetailViewController: UIViewController {
    // MARK: - Nested Type
    private enum LocalizationKey {
        static let barButtonTitle = "barButtonTitle"
        static let delete = "delete"
        static let cancel = "cancel"
        static let share = "share"
        static let more = "more"
    }
    
    enum WriteMode {
        case create
        case update
    }
    
    // MARK: - Properties
    private var locationManager: CLLocationManager!
    private let dateFormatter = DiaryDateFormatter.shared
    private var writeMode = WriteMode.create
    private var longitude: Double?
    private var latitude: Double?
    private var diary: Diary?
    private var id = UUID()
    private var isSave: Bool = true
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderWidth = 0.8
        textView.layer.cornerRadius = 4
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    // MARK: - Initializer
    init(_ diary: Diary?) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        configureLocationManager()
        checkWriteMode()
        configureUI()
        configureLayout()
        configureNavigationBar()
        configureNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("ViewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("ViewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        saveDiaryToStorage()
    }
    
    // MARK: - Methods
    private func configureLocationManager() {
        locationManager.delegate = self
        print(locationManager.requestWhenInUseAuthorization())
    }
    
    private func checkWriteMode() {
        writeMode = diary == nil ? .create : .update
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        switch writeMode {
        case .create:
            title = dateFormatter.nowDateText
            textView.becomeFirstResponder()
        case .update:
            guard let validDiary = diary else { return }
            
            title = validDiary.formattedDateText
            id = validDiary.id
            textView.text = validDiary.sharedText
        }
    }
    
    private func configureLayout() {
        view.addSubview(textView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8)
        ])
    }
    
    private func configureNavigationBar() {
        let buttonItem: UIBarButtonItem = {
            let button = UIBarButtonItem(
                title: LocalizationKey.more.localized(),
                style: .plain,
                target: self,
                action: #selector(presentActionSheet)
            )
            
            return button
        }()
        
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc private func presentActionSheet() {
        let shareActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(
            title: LocalizationKey.cancel.localized(),
            style: .cancel
        )
        
        let shareAction = UIAlertAction(
            title: LocalizationKey.share.localized(),
            style: .default
        ) { [weak self] _ in
            self?.presentActivityView(diary: self?.diary)
        }
        
        let deleteAction = UIAlertAction(
            title: LocalizationKey.delete.localized(),
            style: .destructive
        ) { [weak self] _ in
            
            self?.presentDeleteAlert(diary: self?.diary) { _ in
                self?.isSave = false
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        shareActionSheet.addAction(cancelAction)
        shareActionSheet.addAction(shareAction)
        shareActionSheet.addAction(deleteAction)
        
        present(shareActionSheet, animated: true)
    }
    
    private func configureNotification() {
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
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        textView.contentInset.bottom = keyboardFrame.size.height
        textView.scrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = textView.contentInset
        
        saveDiaryToStorage()
    }
    
    @objc private func didEnterBackground() {
        saveDiaryToStorage()
    }
    
    private func createCurrentDiary() -> Diary? {
        guard let contents = verifyText(text: textView.text) else { return nil }
        let components = contents.split(separator: "\n", maxSplits: 1)
        
        guard let title = components.first,
              let date = self.title else { return nil }
        var body = components[safe: 1] ?? ""
        
        if body.first == "\n" {
            body.removeFirst()
        }
        
        let currentDiary = Diary(
            id: id,
            title: String(title),
            body: String(body),
            timeIntervalSince1970: dateFormatter.convertToInterval(from: date)
        )
        
        return currentDiary
    }
    
    private func saveDiaryToStorage() {
        guard let diary = createCurrentDiary() else { return }
        self.diary = diary
        
        if isSave {
            if CoreDataManager.shared.search(id: diary.id) == true {
                CoreDataManager.shared.update(diary)
            } else {
                CoreDataManager.shared.create(diary)
            }
        }
    }
    
    private func verifyText(text: String) -> String? {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        
        if trimmedText.isEmpty {
            return nil
        } else {
            return trimmedText
        }
    }
}

extension DiaryDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //location5
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation() // 중요!
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
        case .denied:
            print("GPS 권한 요청 거부됨")
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

            // the most recent location update is at the end of the array.
            let location: CLLocation = locations[locations.count - 1]
            let longitude1: CLLocationDegrees = location.coordinate.longitude
            let latitude1: CLLocationDegrees = location.coordinate.latitude
        let lon = Double(longitude1)
        let lat = Double(latitude1)
        self.latitude = lat
        self.longitude = lon
        
        print(self.latitude)
        print(self.longitude)
    }
}
