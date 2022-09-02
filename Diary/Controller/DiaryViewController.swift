//
//  DiaryViewController.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/17.
//

import UIKit
import CoreLocation

final class DiaryViewController: UIViewController {
    
    private let diaryView = DiaryView()
    private var diaryViewModel = DiaryViewModel()
    private var locationManger = CLLocationManager()
    private let networkManager = NetworkManager()
    
    override func loadView() {
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.diaryView.diaryTextView.delegate = self
        self.setupNavigationbar()
        self.setupLoactionManger()
        self.enterBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            locationManger.startUpdatingLocation()
        } else {
            print("off")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.fetchWeatherData(latitude: diaryViewModel.latitude ?? "", longitude: diaryViewModel.longitude ?? "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeRegisterForKeyboardNotification()
        self.saveDiaryData()
    }
    
    private func setupNavigationbar() {
        let date = Date().dateFormatted()
        self.navigationItem.title = date
    }
    
    private func setupLoactionManger() {
        self.locationManger.delegate = self
        self.locationManger.requestWhenInUseAuthorization()
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardDownAction),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc private func keyBoardShow(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary,
              let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        self.diaryView.changeTextViewBottomAutoLayout(keyboardHeight)
    }
    
    private func saveDiaryData() {
        guard let itemTitle = diaryViewModel.itemTitle,
              let itemBody = diaryViewModel.itemBody,
              let itemIcon = diaryViewModel.icon else {
            return
        }
        
        diaryViewModel.coreDataManager.updateData(item: DiaryContent(id: diaryViewModel.id,
                                                                     icon: WeatherIcon.makeURL(icon: itemIcon),
                                                                     title: itemTitle,
                                                                     body: itemBody,
                                                                     createdAt: Date().timeIntervalSince1970))
    }
    
    @objc private func keyBoardDownAction(_ sender: Notification) {
        self.diaryView.changeTextViewBottomAutoLayout()
    }
    
    private func enterBackground() {
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                               object: nil,
                                               queue: .main) { [self] notification in
            self.saveDiaryData()
        }
    }
    
    private func fetchWeatherData(latitude: String, longitude: String) {
        let request = OpenWeatherRequest(method: .get,
                                         baseURL: URLHost.openWeather.url,
                                         query: [URLQuery.latitude.text: latitude,
                                                 URLQuery.longitude.text: longitude,
                                                 URLQuery.apiKey.text: APIkey.key],
                                         path: URLAdditionalPath.data.value)
        
        networkManager.dataTask(with: request) { [self] result in
            switch result {
            case .success(let responseData):
                guard let weatherData: WeatherData = try? JSONDecoder().decode(WeatherData.self,
                                                                               from: responseData) else { return }
                
                diaryViewModel.icon = weatherData.weather[0].icon
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}

extension DiaryViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let diaryText = textView.text.components(separatedBy: "\n")
        let body = diaryText[diaryText.startIndex + 1..<diaryText.endIndex].joined(separator: "")
        
        guard let title = diaryText.first else { return }
        
        diaryViewModel.itemTitle = title
        diaryViewModel.itemBody = body
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        diaryViewModel.realTimeTypingValue = text
        if diaryViewModel.islineChanged {
            diaryView.diaryTextView.typingAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
            return true
        }
        diaryView.diaryTextView.typingAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)]
        return true
    }
}

extension DiaryViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]

        diaryViewModel.latitude = location.coordinate.latitude.description
        diaryViewModel.longitude = location.coordinate.longitude.description
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
