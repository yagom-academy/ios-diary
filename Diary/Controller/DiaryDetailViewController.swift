//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import UIKit
import CoreLocation

final class DiaryDetailViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    private var diaryItem: Diary?
    private var state: DiaryState
    private let manager = PersistenceManager()
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureInitailView()
        setupNotification()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
//        print(locationManager.location?.coordinate.latitude)
//        print(locationManager.location?.coordinate.longitude)
        guard let location = locationManager.location?.coordinate else { return }
        
        print(DiaryEndPoint.weather(lat: location.latitude, lon: location.longitude).url)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if state == .create {
            diaryTextView.becomeFirstResponder()
        }
    }
    
    init(diaryItem: Diary? = nil, state: DiaryState) {
        self.diaryItem = diaryItem
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIScene.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureInitailView() {
        self.navigationController?.delegate = self
        
        guard let diaryItem = diaryItem else {
            self.navigationItem.title = Date().convertToDate()
            
            return
        }
        
        self.navigationItem.title = diaryItem.date?.convertToDate()
        self.diaryTextView.text = diaryItem.content
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(endEditingDiary),
                                               name: UIScene.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(endEditingDiary),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func endEditingDiary() {
        guard !diaryTextView.text.isEmpty else { return }
        
        let content = diaryTextView.text
        
        switch state {
        case .create:
            let date = Date()
            manager.createContent(content, date) { [weak self] result in
                switch result {
                case .success(let diary):
                    self?.diaryItem = diary
                    self?.state = .edit
                case .failure(let error):
                    self?.showFailAlert(error: error)
                }
            }
        case .edit:
            guard let diary = diaryItem else { return }
            
            manager.updateContent(at: diary, content) { [weak self] result in
                switch result {
                case .success():
                    return
                case .failure(let error):
                    self?.showFailAlert(error: error)
                }
            }
        }
    }
    
    @objc private func doneButtonTapped(sender: Any) {
        self.view.endEditing(true)
    }
}

extension DiaryDetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let diaryViewController = viewController as? DiaryViewController else { return }
        
        endEditingDiary()
        diaryViewController.fetchDiary()
    }
}

extension DiaryDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한 요청 거부됨")
            locationManager.requestWhenInUseAuthorization()
        default:
            print("GPS: Default")
        }
    }
}

// MARK: UI
extension DiaryDetailViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureTextView()
        configureNavigationController()
    }
    
    private func configureNavigationController() {
        let image = UIImage(systemName: "ellipsis.circle")
        let rightItem = UIBarButtonItem(image: image,
                                        style: .plain,
                                        target: self,
                                        action: #selector(showActionSheet))
        
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func configureTextView() {
        diaryTextView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(diaryTextView)
        diaryTextView.addDoneButton(title: "Done",
                                    target: self,
                                    selector: #selector(doneButtonTapped))
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    func showDeleteAlert() {
        let alert = UIAlertController(title: "진짜요?",
                                      message: "정말로 삭제하시겠어요?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let diaryItem = self?.diaryItem else { return }
            
            self?.manager.deleteContent(at: diaryItem, completion: { [weak self] result in
                switch result {
                case .success():
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self?.showFailAlert(error: error)
                }
            })
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    @objc private func showActionSheet() {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            guard let text = self.diaryItem?.content else { return }
            
            self.showActivityView(text)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.showDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancle", style: .cancel)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

fileprivate extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                       target: nil,
                                       action: nil)
        let barButton = UIBarButtonItem(title: title,
                                        style: .plain,
                                        target: target,
                                        action: selector)
        
        toolBar.setItems([flexible, barButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
}
