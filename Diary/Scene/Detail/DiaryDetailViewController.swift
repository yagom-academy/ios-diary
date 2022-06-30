//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import UIKit
import CoreLocation

protocol DiaryDetailViewDelegate: AnyObject {
    func update(diary: Diary)
    func delete(diary: Diary)
}

extension DiaryDetailViewController {
    static func instance(coordinator: DiaryDetailCoordinator, diary: Diary) -> DiaryDetailViewController {
        return DiaryDetailViewController(coordinator: coordinator, diary: diary)
    }
}

final class DiaryDetailViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var doneButton = UIBarButtonItem(
        title: "완료",
        style: .plain,
        target: self,
        action: #selector(doneButtonDidTap)
    )
    
    private var diary: Diary
    private let coordinator: DiaryDetailCoordinator
    private let locationManager = CLLocationManager()
    weak var delegate: DiaryDetailViewDelegate?
    
    init(coordinator: DiaryDetailCoordinator, diary: Diary) {
        self.coordinator = coordinator
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        attribute()
        addSubViews()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if diary.isEmpty {
            diaryTextView.becomeFirstResponder()
        }
    }
    
    @objc
    private func doneButtonDidTap() {
        diaryTextView.resignFirstResponder()
        navigationItem.rightBarButtonItems?.removeLast()
    }
    
    @objc
    private func moreButtonDidTap() {
        AlertBuilder(viewController: self)
            .addAction(title: "Share...", style: .default) { [weak self] in
                guard let text = self?.diaryTextView.text else { return }
                
                let activityViewController = UIActivityViewController(
                    activityItems: [text],
                    applicationActivities: nil
                )
                
                self?.present(activityViewController, animated: true)
            }
            .addAction(title: "Delete", style: .destructive) { [weak self] in
                AlertBuilder(viewController: self)
                    .addAction(title: "취소", style: .cancel)
                    .addAction(title: "삭제", style: .destructive) { [weak self] in
                        guard let diary = self?.diary else { return }
                        
                        self?.delegate?.delete(diary: diary)
                        self?.coordinator.popViewController(animated: true)
                    }
                    .show(title: "진짜요?", message: "정말로 삭제하시겠어요?", style: .alert)
            }
            .addAction(title: "Cancel", style: .cancel)
            .show(style: .actionSheet)
    }
    
    @objc
    private func updateDiary() {
        guard let texts = diaryTextView.text else { return }
        
        let newDiary: Diary
        
        if let index = texts.firstIndex(of: "\n") {
            let title = String(texts[..<index])
            let body = texts[index...].trimmingCharacters(in: .newlines)
            
            newDiary = Diary(
                title: title,
                body: body,
                createdDate: diary.createdDate,
                id: diary.id,
                weather: diary.weather
            )
        } else {
            newDiary = Diary(
                title: texts,
                body: "",
                createdDate: diary.createdDate,
                id: diary.id,
                weather: diary.weather
            )
        }
        
        delegate?.update(diary: newDiary)
    }
    
    private func setDiaryWeather(with location: CLLocationCoordinate2D?) async {
        do {
            let weather = try await requestWeather(location: location)
            diary.setWeather(weather)
        } catch {
            AlertBuilder(viewController: self)
                .addAction(title: "확인", style: .default)
                .show(title: "서버연결에 실패했습니다", message: "다시 시도해 보세요", style: .alert)
        }
    }
    
    private func requestWeather(location: CLLocationCoordinate2D?) async throws -> Weather? {
        guard let location = location else { return nil }

        let openWeahterAPI = OpenWeatherAPI(latitude: location.latitude, longitude: location.longitude)
        let task = NetworkManager().request(api: openWeahterAPI)
        
        switch await task.result {
        case .success(let data):
            return WeatherInfomation.parse(data)?.weather.first
        case .failure(let error):
            throw error
        }
    }
}

// MARK: TextViewDelegate

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if navigationItem.rightBarButtonItems?.count == 1 {
            navigationItem.rightBarButtonItems?.append(doneButton)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateDiary()
    }
}
// MARK: - CLLocationManagerDelegate

extension DiaryDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        
        Task {
            await setDiaryWeather(with: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task {
            await setDiaryWeather(with: nil)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager.requestLocation()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            locationManager.requestLocation()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            break
        }
    }
}

// MARK: - SetUp

extension DiaryDetailViewController {
    private func setUp() {
        setUpNavigationBar()
        setUpNotification()
        setUpTextView()
        setUpLocationManager()
    }
    
    private func setUpNavigationBar() {
        title = diary.createdDate.formattedString
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(moreButtonDidTap)
        )
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDiary),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    private func setUpTextView() {
        if diary.isEmpty == false {
            diaryTextView.text = diary.title + "\n\n" + diary.body
        }
        
        diaryTextView.contentOffset = .zero
        diaryTextView.delegate = self
    }
    
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        view.addSubview(diaryTextView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
