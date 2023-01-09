//
//  CoreDataManager.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/26.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
    
    private let modelName = "DiaryData"
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    func fetchData() -> Result<[DiaryData], DataError> {
        var diaryDataList: [DiaryData] = []
        guard let context = context else { return .failure(.coreDataError) }
        
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        
        let dataOrder = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [dataOrder]
        
        do {
            if let dataList = try context.fetch(request) as? [DiaryData] {
                diaryDataList = dataList
            }
        } catch {
            return .failure(.coreDataError)
        }
        
        return .success(diaryDataList)
    }
    
    func saveData(diaryData: CurrentDiary, weatherData: CurrentWeather) throws -> UUID? {
        guard let context = context else {
            throw DataError.coreDataError
        }
        guard let entity = NSEntityDescription.entity(forEntityName: self.modelName,
                                                      in: context) else {
            throw DataError.coreDataError
        }
        guard let content = NSManagedObject(entity: entity,
                                            insertInto: context) as? DiaryData else {
            throw DataError.coreDataError
        }
        
        content.id = UUID()
        content.createdAt = diaryData.createdAt
        content.contentText = diaryData.contentText
        
        let weather = WeatherData(context: context)
        weather.iconID = weatherData.iconID
        weather.main = weatherData.main
        
        content.weather = weather
        
        if context.hasChanges {
            do {
                try context.save()
                return content.id
            } catch {
                throw DataError.coreDataError
            }
        }
        
        return content.id
    }
    
    func updateData(id: UUID, contentText: String) throws {
        guard let context = context else {
            throw DataError.coreDataError
        }
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            guard let fetchedDatas = try context.fetch(request) as? [DiaryData] else {
                throw DataError.coreDataError
            }
            guard let diaryData = fetchedDatas.first else {
                throw DataError.coreDataError
            }
            
            diaryData.setValue(contentText, forKey: "contentText")
            if context.hasChanges {
                do {
                    try context.save()
                    return
                } catch {
                    throw DataError.coreDataError
                }
            }
        } catch {
            throw DataError.coreDataError
        }
        return
    }

    func deleteData(id: UUID) throws {
        guard let context = context else {
            throw DataError.coreDataError
        }
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            guard let fetchedDatas = try context.fetch(request) as? [DiaryData] else {
                throw DataError.coreDataError
            }
            guard let diaryData = fetchedDatas.first else {
                throw DataError.coreDataError
            }
            
            context.delete(diaryData)
            
            if context.hasChanges {
                do {
                    try context.save()
                    return
                } catch {
                    throw DataError.coreDataError
                }
            }
        } catch {
            throw DataError.coreDataError
        }
        return
    }
}
