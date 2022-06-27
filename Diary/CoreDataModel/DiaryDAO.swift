//
//  DiaryDAO.swift
//  Diary
//
//  Created by 김태현 on 2022/06/20.
//

import Foundation
import CoreData

final class DiaryDAO {
    static let shared = DiaryDAO()
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(_ newData: DiaryDTO?, isNew: Bool) {
        if isNew {
            create(userData: newData)
        } else {
            update(userData: newData)
        }
    }
    
    private func create(userData: DiaryDTO?) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext),
              let userData = userData else {
            return
        }
        
        let userModel = NSManagedObject(entity: entity, insertInto: viewContext)
        
        guard let (lat, lon) = Location.shared.getLocation() else {
            return
        }
        
        WeatherAPIManager.shared.fetchData(url: EntryPoint.weatherDescription(lat: lat, lon: lon).url) { [weak self] data in
            
            guard let data = try? data.get(),
                  let weather: WeatherDTO = data.convert() else {
                return
            }
            
            let weatherDescription = weather.description
            
            userModel.setValue(userData.identifier, forKey: "identifier")
            
            userModel.setValue(userData.title, forKey: "title")
            userModel.setValue(userData.date, forKey: "date")
            userModel.setValue(userData.body, forKey: "body")
            
            userModel.setValue(weather.icon.first?.icon, forKey: "icon")
            
            userModel.setValue(weatherDescription.temperature, forKey: "temp")
            userModel.setValue(weatherDescription.feelsLike, forKey: "feelsLike")
            userModel.setValue(weatherDescription.minTemperature, forKey: "tempMin")
            userModel.setValue(weatherDescription.maxTempaerature, forKey: "tempMax")
            userModel.setValue(weatherDescription.pressure, forKey: "pressure")
            userModel.setValue(weatherDescription.humidity, forKey: "humidity")
            
            self?.save()
        }
    }
    
    private func save() {
        guard viewContext.hasChanges else {
            return
        }
        
        do {
            try viewContext.save()
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func read() -> [DiaryDTO]? {
        let request = Diary.fetchRequest()
        guard let diary = try? viewContext.fetch(request) else {
            return nil
        }
        
        return convert(diary: diary)
    }
    
    private func convert(diary: [Diary]) -> [DiaryDTO]? {
        return diary.compactMap {
            guard let identifier = $0.identifier,
                  let title = $0.title,
                  let body = $0.body,
                  let date = $0.date,
                  let icon = $0.icon else {
                return nil
            }
            
            return DiaryDTO(identifier: identifier, title: title, body: body, date: date, icon: icon)
        }
    }
    
    func search(identifier: String) -> DiaryDTO? {
        guard let diary = fetch(identifier: identifier) else {
            return nil
        }
        
        return convert(diary: diary)?.first
    }
    
    private func fetch(identifier: String) -> [Diary]? {
        let request = Diary.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        
        request.predicate = predicate
        
        guard let diary = try? viewContext.fetch(request) else {
            return nil
        }
        
        return diary
    }
    
    private func update(userData: DiaryDTO?) {
        func changeData(newData: DiaryDTO?) -> DiaryDTO? {
            guard let newData = newData,
                  let oldData = fetch(identifier: newData.identifier.uuidString),
                  var data: DiaryDTO = convert(diary: oldData)?.first else {
                return nil
            }
            data.editData(newData)
            return data
        }
        
        guard let userData = changeData(newData: userData),
              let diary = getObject(identifier: userData.identifier.uuidString) else {
            return
        }
        
        diary.setValue(userData.title, forKey: "title")
        diary.setValue(userData.body, forKey: "body")
        
        save()
    }
    
    private func getObject(identifier: String) -> NSManagedObject? {
        guard let diary = fetch(identifier: identifier)?.first as? NSManagedObject else {
            return nil
        }
        
        return diary
    }
    
    func delete(identifier: String?) {
        guard let identifier = identifier,
              let diary = getObject(identifier: identifier) else {
            return
        }
        
        deleteContext(object: diary)
    }
    
    private func deleteContext(object: NSManagedObject) {
        viewContext.delete(object)
        save()
    }
}
