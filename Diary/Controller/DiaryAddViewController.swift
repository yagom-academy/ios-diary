//
//  DiaryAddViewController.swift
//  Diary
//
//  Created by Minseong, Lingo
//

import UIKit
import CoreLocation

final class DiaryAddViewController: DiaryBaseViewController {
  private let storageManger: DiaryStorageManager
  private let locationManager: CLLocationManager
  private let weatherService: WeatherService
  private var weather: Weather?

  init(storageManger: DiaryStorageManager) {
    self.storageManger = storageManger
    self.locationManager = CLLocationManager()
    self.weatherService = WeatherService(networking: .init(session: .shared))
    super.init(nibName: nil, bundle: nil)
    self.observeDidEnterBackgroundNotification()
    self.initializeLocationManager()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.bodyTextView.becomeFirstResponder()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.createDiary()
  }

  private func observeDidEnterBackgroundNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.createDiary),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
    )
  }

  @objc private func createDiary() {
    self.storageManger.createDiary(text: self.bodyTextView.text, weather: self.weather)
  }

  private func initializeLocationManager() {
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    self.locationManager.delegate = self
  }
}

extension DiaryAddViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let coordinate = locations.last?.coordinate {
      self.locationManager.stopUpdatingLocation()
      self.weatherService.fetchWeather(lat: coordinate.latitude, lon: coordinate.longitude) { [weak self] weather in
        self?.weather = weather
      }
    }
  }
}
