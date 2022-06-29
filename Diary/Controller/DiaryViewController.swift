//
//  DiaryViewController.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/14.
//

import UIKit
import CoreLocation

protocol DiaryViewControllerDelegate: AnyObject {
    func updateView()
}

class DiaryViewController: UIViewController {
    lazy var diaryView = DiaryView.init(frame: view.bounds)
    weak var delegate: DiaryViewControllerDelegate?
    var diary: Diary?
    
    private var locationManager: CLLocationManager?
    private var weather: Weather?
    private var iconImage: Data? {
        didSet {
            self.weather?.iconImage = iconImage
            DispatchQueue.main.async {
                self.setDiary()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
        setLocationManager()
    }
    
    private func setInitialView() {
        self.view = diaryView
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveDiary),
                                               name: Notification.Name.sceneDidEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveDiary),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        configureOptionButton()
    }
    
    private func setLocationManager() {
        if diary == nil {
            locationManager = CLLocationManager()
            guard let locationManager = locationManager else {
                return
            }
            
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func configureOptionButton() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(touchOptionButton))
        
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    private func setDiary() {
        var convertedTextArray = convertedTextArray()
        diary = Diary(title: convertedTextArray.isEmpty ? "새로운 일기" : convertedTextArray.removeFirst(),
                      body: convertedTextArray.isEmpty ? "본문 없음" : convertedTextArray[0],
                      text: diaryView.diaryTextView.text ?? "",
                      createdAt: Date().timeIntervalSince1970,
                      id: UUID(),
                      weather: self.weather)
        
        update()
    }
    
    private func editDiary() {
        var convertedTextArray = convertedTextArray()
        diary?.title = convertedTextArray.isEmpty ? "새로운 일기" : convertedTextArray.removeFirst()
        diary?.body = convertedTextArray.isEmpty ? "본문 없음" : convertedTextArray[0]
        diary?.text = diaryView.diaryTextView.text ?? ""
        
        update()
    }
    
    private func convertedTextArray() -> [String] {
        let textArray = diaryView.diaryTextView.text.components(separatedBy: "\n")
        let convertedTextArray: [String] = textArray.compactMap {
            if !$0.trimmingCharacters(in: .whitespaces).isEmpty {
                return $0.trimmingCharacters(in: .whitespaces)
            }
            
            return nil
        }
        
        return convertedTextArray
    }
    
    private func update() {
        do {
            guard let diaryData = self.diary else {
                return
            }

            try CoreDataManager.shared.update(diaryData)
        } catch {
            showErrorAlert("업데이트에 실패했습니다")
        }
        
        delegate?.updateView()
    }
    
    private func touchShareButton() {
        let text = diaryView.diaryTextView.text ?? ""
        let share = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.present(share, animated: true)
    }
    
    private func touchDeleteButton() {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            guard let diary = self.diary else {
                return
            }
            
            do {
                try CoreDataManager.shared.delete(diary)
                self.delegate?.updateView()
                self.navigationController?.popViewController(animated: true)
            } catch {
                self.showErrorAlert("삭제에 실패했습니다")
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func touchOptionButton() {
        diaryView.diaryTextView.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            self.touchShareButton()
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.touchDeleteButton()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func saveDiary() {
        if diary == nil {
            setWeatherInfo()
        } else {
            editDiary()
        }
    }
}

// MARK: - weather info
extension DiaryViewController: CLLocationManagerDelegate {
    private func getCoordinate() -> (latitude: Double, longitude: Double)? {
        let coordinate = locationManager?.location?.coordinate
        guard let latitude = coordinate?.latitude else {
            return nil
        }
        
        guard let longtitude = coordinate?.longitude else {
            return nil
        }
        
        return (latitude, longtitude)
    }
    
    private func setWeatherInfo() {
        let apiKey = "783e209f3bc56998f3575fbe0168df43"
        
        guard let coordinate = getCoordinate() else {
            return
        }

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)") else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            self.parse(data)
        }
        
        dataTask.resume()
    }
    
    private func setWeatherImage(_ iconID: String) {
        guard let url = URL(string: "https://openweathermap.org/img/w/\(iconID).png") else { return }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            self.iconImage = data
        }
        
        dataTask.resume()
    }
    
    private func parse(_ data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return
        }
        
        guard let weather = json["weather"] as? [[String: Any]] else {
            return
        }
        
        for element in weather {
            guard let main = element["main"] as? String else {
                return
            }
            
            guard let iconID = element["icon"] as? String else {
                return
            }
            
            self.setWeatherImage(iconID)
            self.weather = Weather(main: main, iconID: iconID)
        }
    }
}
