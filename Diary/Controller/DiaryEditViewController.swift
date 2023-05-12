//
//  DiaryEditViewController.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/25.
//

import UIKit
import CoreLocation

final class DiaryEditViewController: UIViewController {
    private var diaryData: DiaryData?
    private var diaryType: DiaryType
    private var locationManager: CLLocationManager?
    
    private let textView: UITextView = {
        let textView = UITextView()
        
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let titleView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let weatherImageView = UIImageView()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.adjustsFontForContentSizeCategory  = true
        
        return label
    }()
    
    init(diaryData: DiaryData? = nil, type: DiaryType = .new) {
        self.diaryData = diaryData
        self.diaryType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLocationManager()
        configureUI()
        configureText()
        configureTitle()
        setupNotification()
        showKeyboard()
        setupLocationManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        autoSaveDiary()
    }
    
    private func createLocationManager() {
        if diaryType == .new {
            self.locationManager = CLLocationManager()
        }
    }
    
    private func configureUI() {
        let image = UIImage(systemName: "ellipsis.circle")
        let navigationRightButton = UIBarButtonItem(image: image,
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(ellipsisButtonTapped))
        
        navigationItem.rightBarButtonItem = navigationRightButton
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor)
        ])
    }
    
    private func configureText() {
        guard let diaryTitle = diaryData?.title else { return }
        let title = checkNoTitle(title: diaryTitle)
        guard let body = diaryData?.body else {
            textView.text = title
            return
        }
        
        textView.text = "\(title)\n\(body)"
    }
    
    private func configureTitle() {
        guard let date = diaryData?.createDate else { return }
        
        switch diaryType {
        case .new:
            dateLabel.text = DateManger.shared.convertToDate(fromDouble: date)
        case .old:
            guard let icon = diaryData?.weatherIcon else { return }
            dateLabel.text = DateManger.shared.convertToDate(fromDouble: date)
            fetchImage(icon: icon)
        }
        
        navigationItem.titleView = createStackView()
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [weatherImageView, dateLabel])
        
        stackView.axis = .horizontal
        
        return stackView
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveDiary),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveDiary),
                                               name: UIApplication.keyboardDidHideNotification,
                                               object: nil)
    }
    
    private func showKeyboard() {
        if diaryType == .new {
            textView.becomeFirstResponder()
        }
    }
    
    private func setupLocationManager() {
        locationManager?.delegate = self
    }
    
    private func divide(text: String?) -> (title: String, body: String?) {
        guard let text = textView.text else {
            return ("", nil)
        }
        guard let spacingIndex = text.firstIndex(of: "\n") else {
            return (checkEmptyTitle(title: text), nil)
        }
        let spacingNextIndex = text.index(after: spacingIndex)
        let title = checkEmptyTitle(title: String(text[..<spacingIndex]))
        let body = String(text[spacingNextIndex...])
        
        return (title, body)
    }
    
    private func checkEmptyTitle(title: String) -> String {
        let removeBlankTitle = title.filter { $0 != " " }
        
        if removeBlankTitle.isEmpty {
            return "제목 없음"
        } else {
            return title
        }
    }
    
    private func checkNoTitle(title: String) -> String {
        if title == "제목 없음" {
            return ""
        } else {
            return title
        }
    }
    
    @objc
    private func ellipsisButtonTapped() {
        textView.resignFirstResponder()
        
        AlertManager().showActionSheet(target: self) { [weak self] in
            guard let self,
                  let id = self.diaryData?.id else { return }
            
            AlertManager().showDeleteAlert(target: self) {
                CoreDataManger.shared.deleteDiary(id: id)
                self.navigationController?.popViewController(animated: true)
            }
        } shareCompletion: { [weak self] in
            guard let self else { return }
            
            ActivityViewManager().showActivityView(target: self)
        }
    }
    
    @objc
    private func saveDiary() {
        autoSaveDiary()
    }
    
    private func autoSaveDiary(icon: String? = nil, main: String? = nil) {
        let (title, body) = divide(text: textView.text)
        
        switch diaryType {
        case .new:
            let diary = CoreDataManger.shared.createDiary(title: title,
                                                          body: body,
                                                          icon: icon,
                                                          main: main)
            
            self.diaryData = diary
            self.diaryType = .old
        case .old:
            guard let id = diaryData?.id else { return }
            
            CoreDataManger.shared.updateDiary(id: id, title: title, body: body)
        }
    }
}

extension DiaryEditViewController: CLLocationManagerDelegate {
    // 생성될 때, 권한 바뀔 때
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
            locationManager?.stopUpdatingLocation()
        case .restricted, .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .denied:
            locationManager?.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            WeatherProvider().fetchData(.weatherInfo(latitude: coordinate.latitude,
                                                     longitude: coordinate.longitude)) { [weak self] result in
                switch result {
                case .success(let data):
                    do {
                        let weatherInfo = try JSONDecoder().decode(WeatherJSONData.self, from: data)
                        
                        DispatchQueue.main.async {
                            self?.autoSaveDiary(icon: weatherInfo.weatherIcon,
                                                main: weatherInfo.weatherMain)
                            self?.fetchImage(icon: weatherInfo.weatherIcon)
                            self?.configureTitle()
                        }
                    } catch {
                        print("error")
                    }
                case .failure:
                    print("error")
                }
            }
        }
    }
    
    func fetchImage(icon: String) {
        WeatherProvider().fetchData(.weatherImage(iconCode: icon)) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.weatherImageView.image = UIImage(data: data)
                }
            case .failure:
                print("error")
            }
        }
    }
}
