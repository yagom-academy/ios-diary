//
//  WriteViewController.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/15.
//

import UIKit
import CoreLocation

final class WriteViewController: DiaryBaseViewController ,CLLocationManagerDelegate {
  private lazy var baseView = BaseTextView(frame: view.bounds)
  private var weatherData: Weather?
  private let locationManager = CLLocationManager()
  
  override func loadView() {
    super.loadView()
    view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fecthData()
    configureUI()
    addKeyboardObserver(action: #selector(keyboardWillShow))
    addGesture()
    addSaveDiaryObserver(action: #selector(diaryDataSave))
    setlocationManager()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    saveDiaryData()
  }
  
  deinit {
    removeKeyboardObserver()
    removeSaveDiaryObserver()
  }
  
  @objc func diaryDataSave() {
    saveDiaryData()
  }
  
  private func configureUI() {
    view.backgroundColor = .systemBackground
    navigationItem.title = Date().setKoreaDateFormat(dateFormat: .yearMonthDay)
  }
  
  private func saveDiaryData() {
    guard let text = baseView.textView.text else {
      return
    }
    
    guard let weather = weatherData else {
      return
    }
    
    DiaryData.create (
      title: seperateTitle(from: text),
      content: seperateContent(from: text),
      identifier: UUID().uuidString,
      date: Date(),
      main: weather.main,
      iconID: weather.icon)
  }
  
  private func setlocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.stopUpdatingLocation()
  }
  
  private func fecthData() {
    guard let latitude = locationManager.location?.coordinate.latitude,
          let longitude = locationManager.location?.coordinate.longitude else {
      return
    }
    
    WeatherService().fetch(api: .weatherApi(lat: latitude, lon: longitude)) { result in
      switch result {
      case .success(let weatherResponse):
        guard let weather = try? JSONDecoder().decode(WeatherResponse.self, from: weatherResponse) else {
          return
        }
        self.weatherData = weather.weather.first
      case .failure(_): break
      }
    }
  }
}


// MARK: - keyboard

private extension WriteViewController {
  func addGesture() {
    view.addGestureRecognizer(setSwipeGesture(action:#selector(keyboardHideDidSwipeDown)))
  }
  
  @objc func keyboardHideDidSwipeDown(gesture: UISwipeGestureRecognizer) {
    view.endEditing(true)
    saveDiaryData()
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
          let keyboardFrame = userInfo as? CGRect else { return }
    
    let contentInset = UIEdgeInsets(
      top: .zero,
      left: .zero,
      bottom: keyboardFrame.height,
      right: .zero
    )
    
    baseView.textView.contentInset = contentInset
    baseView.textView.verticalScrollIndicatorInsets = contentInset
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    let contentInset = UIEdgeInsets.zero
    baseView.textView.contentInset = contentInset
    baseView.textView.scrollIndicatorInsets = contentInset
  }
}
