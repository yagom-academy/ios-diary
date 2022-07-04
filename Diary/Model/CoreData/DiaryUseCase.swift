//
//  DiaryUseCase.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/16.
//

import CoreData
import CoreLocation

final class DiaryUseCase {
    private let containerManager: ContainerManagerable
    private let weatherUseCase: WeatherDataUseCase
    let context: NSManagedObjectContext
    let diaryEntity: NSEntityDescription?
    
    private var location: Location? {
            let locationManager = CLLocationManager()
            locationManager.startUpdatingLocation()
            guard let lat = locationManager.location?.coordinate.latitude,
                  let lon = locationManager.location?.coordinate.longitude else {
                return nil
            }
            
            return Location(lat: lat, lon: lon)
    }
    
    init(containerManager: ContainerManagerable, weatherUseCase: WeatherDataUseCase) {
        self.containerManager = containerManager
        self.weatherUseCase = weatherUseCase
        context = containerManager.persistentContainer.viewContext
        diaryEntity = NSEntityDescription.entity(forEntityName: DiaryInfo.entityName, in: context)
    }
    
    private func filterDiaryData(key: UUID) throws -> [NSManagedObject] {
        let request = DiaryData.fetchRequest()
        let predicate = NSPredicate(format: "key = %@", key.uuidString)
        request.predicate = predicate
        let diarys = try context.fetch(request)
        let objectDiarys = diarys as [DiaryData]
        return objectDiarys
    }
    
    @discardableResult
    func create(element: DiaryInfo) ->  Result<DiaryInfo, Error> {
        let key = UUID()
        
        guard let diaryEntity = diaryEntity,
              let diaryData = NSManagedObject(entity: diaryEntity, insertInto: context) as? DiaryData else {
            return .failure(CoreDataError.createError)
        }
        
        diaryData.title = element.title
        diaryData.body = element.body
        diaryData.date = element.date
        diaryData.key = key
        do {
            try context.save()
        } catch {
            return .failure(error)
        }
        let diaryInfo = DiaryInfo(title: element.title, body: element.body, date: element.date, key: key)

        return .success(diaryInfo)
    }
    
    func read() -> Result<[DiaryInfo], Error> {
        let fetchRequest = DiaryData.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        guard let diarys = try? context.fetch(fetchRequest) else {
            return .failure(CoreDataError.readError)
        }
        
        let diaryInfoArray = diarys.map { diary -> DiaryInfo in
            return DiaryInfo(title: diary.title,
                             body: diary.body,
                             date: diary.date,
                             key: diary.key,
                             weather: diary.weather,
                             icon: diary.icon)
        }
        
        return .success(diaryInfoArray)
    }
    
    func update(element: DiaryInfo) -> Result<Void, Error> {
        guard let key = element.key else {
            return .failure(CoreDataError.updateError)
        }
        do {
            let diarys = try filterDiaryData(key: key)
            guard diarys.count > 0 else {
                return .failure(CoreDataError.updateError)
            }
            let diary = diarys[0]
            diary.setValue(element.title, forKey: "title")
            diary.setValue(element.body, forKey: "body")
            try context.save()
        } catch {
            return .failure(error)
        }
        return .success(Void())
    }
    
    func delete(element: DiaryInfo) -> Result<Void, Error> {
        let request = DiaryData.fetchRequest()
        
        guard let uuidString = element.key?.uuidString else {
            return .failure(CoreDataError.deleteError)
        }
        
        do {
            let predicate = NSPredicate(format: "key = %@", uuidString)
            request.predicate = predicate
            let result = try context.fetch(request)
            let resultArray = result as [DiaryData]
            
            guard resultArray.count > 0 else {
                return .failure(CoreDataError.deleteError)
            }
            
            context.delete(resultArray[0])
            try context.save()
        } catch {
            return .failure(error)
        }
        return .success(Void())
    }
    
    func asyncUpdate(element: DiaryInfo,
                     completionHandler: @escaping (DiaryInfo) -> Void,
                     errorHandler: @escaping (Error) -> Void) {
        if let location = location {
            weatherUseCase.requestWeatherData(location: location) { (weatherDatas: WeatherData) in
                do {
                    guard let weatherData = weatherDatas.weather.first else {
                        throw NetworkError.dataError
                    }
                    
                    guard let key = element.key else {
                        throw CoreDataError.updateError
                    }
                    
                    let diarys = try self.filterDiaryData(key: key)
                    
                    guard let diary = diarys.first as? DiaryData else {
                        throw CoreDataError.readError
                    }
                    
                    diary.setValue(weatherData.main, forKey: "weather")
                    diary.setValue(weatherData.icon, forKey: "icon")
                    
                    try self.context.save()
                    
                    completionHandler(DiaryInfo(title: diary.title,
                                                body: diary.body,
                                                date: diary.date,
                                                key: diary.key,
                                                weather: diary.weather,
                                                icon: diary.icon)
                    )
                } catch {
                    errorHandler(error)
                }
            } errorHandler: { error in
                errorHandler(error)
            }
        }
    }
}

#if DEBUG
extension DiaryUseCase {
    func readOne(key: UUID) -> DiaryInfo? {
        guard let diarys = try? filterDiaryData(key: key) as? [DiaryData],
                  diarys.count == 1 else {
            return nil
        }
        let diary = diarys.first
        
        return DiaryInfo(title: diary?.title, body: diary?.body, date: diary?.date, key: diary?.key)
    }
}
#endif
