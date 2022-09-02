//
//  DiaryContentViewModel.swift
//  Diary
//
//  Created by Hugh,Derrick kim on 2022/08/27.
//

import Foundation

final class DiaryContentViewModel: DiaryViewModelLogic {
    private var dataManager: DataManageLogic?
    private var apiManager: APIManager<CurrentWeather>?
    private var locationManager = LocationManager.shared
    
    var createdAt: Date?
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    
    var iconURL: String = ""
    
    var diaryContents: [DiaryContent]? {
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet{
            self.showAlertClosure?()
        }
    }
    
    init() {
        dataManager = CoreDataManager()
        registerLocation()
        fetch()
    }
    
    func save(_ text: String, _ date: Date) {
        guard let data = convertToDiaryContent(text, date)  else {
            return
        }
        
        do {
            try dataManager?.save(data: data)
        } catch CoreDataError.noneEntity {
            self.alertMessage = CoreDataError.noneEntity.message
        } catch {
            self.alertMessage = CoreDataError.fetchFailure.message
        }
    }
    
    func fetch() {
        do {
            diaryContents = try dataManager?.fetch()
        } catch CoreDataError.fetchFailure {
            self.alertMessage = CoreDataError.fetchFailure.message
        } catch {
            self.alertMessage = CoreDataError.noneEntity.message
        }
    }
    
    func filterData(text: String) {
        let filter = diaryContents?.filter { (data: DiaryContent) -> Bool in
            return data.title.uppercased().contains((text.uppercased()))
        }
        
        guard let filteredData = filter else {
            return
        }
        
        if filteredData.isEmpty {
            fetch()
        } else {
            diaryContents = filteredData
        }
    }
    
    func fetchWeatherData() {
        apiManager?.requestAndDecode(dataType: CurrentWeather.self, completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data.weather.first?.icon else {
                    return
                }
                
                self?.iconURL = WeatherAPIConst.baseIconURL + data + WeatherAPIConst.imageScale
            case .failure(let error):
                self?.alertMessage = error.description
            }
        })
    }
    
    func registerLocation() {
        guard let latitude = locationManager.latitude,
              let longitude = locationManager.longitude else {
            return
        }
        
        apiManager = APIManager(url: WeatherAPIConst.baseURL, latitude: latitude, longitude: longitude)
    }
    
    func update(_ text: String) {
        guard let date = createdAt,
              let data = convertToDiaryContent(text, date)  else {
            return
        }
        
        do {
            try dataManager?.update(data: data)
        } catch CoreDataError.fetchFailure {
            self.alertMessage = CoreDataError.fetchFailure.message
        } catch {
            self.alertMessage = CoreDataError.noneEntity.message
        }
    }
    
    func remove() {
        guard let date = createdAt else {
            return
        }
        
        do {
            try dataManager?.remove(date: date)
            fetch()
        } catch CoreDataError.fetchFailure {
            self.alertMessage = CoreDataError.fetchFailure.message
        } catch {
            self.alertMessage = CoreDataError.noneEntity.message
        }
    }
    
    private func convertToDiaryContent(_ text: String, _ date: Date) -> DiaryContent? {
        var data = text.split(separator: Character(Const.nextLineString), maxSplits: 2).map{ String($0) }
        let title = data.remove(at: 0)
        let body = data.count >= 1 ? data.joined(separator: String(Const.nextLineString)) : Const.emptyString
        

        return DiaryContent(title: title, body: body, createdAt: date, iconURL: iconURL)
    }
}
