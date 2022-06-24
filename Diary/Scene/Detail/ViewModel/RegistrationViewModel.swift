//
//  RegistrationViewModel.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/22.
//

import Foundation
import CoreLocation

final class RegistrationViewModel {
    private(set) var createdAt = Date().timeIntervalSince1970
    private let diaryId = UUID().uuidString
    private var coordinate: CLLocationCoordinate2D?
    private var icon: String?
}

extension RegistrationViewModel {
    func saveDiary(text: String?) {
        guard let content = text,
                content.isEmpty == false
        else {
            return
        }
        
        var splitedText = content.components(separatedBy: "\n")
        let title = splitedText.removeFirst()
        let body = splitedText.joined(separator: "\n")

        let diary = Diary(title: title, createdAt: createdAt, body: body, id: diaryId, icon: icon ?? "")
        
        PersistenceManager.shared.createData(by: diary)
    }
    
    private func requestWeather() {
        guard let coordinate = coordinate else {
            self.icon = nil
            return
        }
        
        RequestManager.shared.requestAPI(by: coordinate) { result in
            switch result {
            case .success(let result):
                self.icon = result.weather.first?.icon
            case .failure:
                self.icon = nil
            }
        }
    }
    
    func setUpLocation(by coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        requestWeather()
    }
}
