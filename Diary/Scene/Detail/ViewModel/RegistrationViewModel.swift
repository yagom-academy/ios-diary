//
//  RegistrationViewModel.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/22.
//

import Foundation
import CoreLocation

final class RegistrationViewModel {
    private(set) var locationManager = CLLocationManager()
    private(set) var createdAt = Date().timeIntervalSince1970
    private let diaryId = UUID().uuidString
    private var coordinate: CLLocationCoordinate2D?
    private var icon: String?
    private let networkManager = NetworkManager()
    private var currentText: String?
}

extension RegistrationViewModel {
    
    // MARK: Input
    
    func viewWillDisappear() throws {
        try saveDiary()
    }
    
    func didEnterBackground() throws {
        try saveDiary()
    }
    
    func keyboardWillHide() throws {
        try saveDiary()
    }
    
    func textViewDidChange(text: String) {
        currentText = text
    }
    
    func didUpdateLocations(by coordinate: CLLocationCoordinate2D) {
        setUpLocation(by: coordinate)
    }
    
    // MARK: Output
    
    private func saveDiary() throws {
        guard let content = currentText,
                content.isEmpty == false
        else {
            return
        }
        
        var splitedText = content.components(separatedBy: "\n")
        let title = splitedText.removeFirst()
        let body = splitedText.joined(separator: "\n")

        let diary = Diary(title: title, createdAt: createdAt, body: body, id: diaryId, icon: icon ?? "")
        
        try PersistenceManager.shared.createData(by: diary)
    }
    
    private func setUpLocation(by coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        requestWeather()
    }
    
    private func requestWeather() {
        guard let coordinate = coordinate else {
            self.icon = nil
            return
        }
        
        let endpoint = EndpointStorage
            .weatherInfo(coordinate.latitude, coordinate.longitude)
            .endPoint
        
        networkManager.requestAPI(with: endpoint) { [weak self] (result: Result<Weather, Error>) in
            switch result {
            case .success(let result):
                self?.icon = result.weather.first?.icon
            case .failure:
                self?.icon = nil
            }
        }
    }
}
