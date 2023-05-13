//
//  CoreDataManager.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/28.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.container)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    func create(contents: Contents) throws {
        let storage = ContentsEntity(context: context)
        
        storage.setValue(contents.title, forKey: Constant.title)
        storage.setValue(contents.body, forKey: Constant.body)
        storage.setValue(contents.date, forKey: Constant.date)
        storage.setValue(contents.identifier, forKey: Constant.identifier)
        storage.setValue(contents.weather?.type, forKey: Constant.weatherType)
        storage.setValue(contents.weather?.iconCode, forKey: Constant.weatherIconCode)
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    func read() throws -> [Contents]? {
        let fetchRequest = NSFetchRequest<ContentsEntity>(entityName: ContentsEntity.description())
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            return entitiesToContents(fetchedData)
        } catch {
            throw DiaryError.fetchFailed
        }
    }
    
    func update(contents: Contents) throws {
        guard let identifier = contents.identifier else { return }
        
        do {
            let searchContents = try searchContents(identifier: identifier).first
            
            searchContents?.setValue(contents.title, forKey: Constant.title)
            searchContents?.setValue(contents.body, forKey: Constant.body)
            
            try context.save()
        } catch {
            throw error
        }
    }
    
    func delete(identifier: UUID) throws {
        do {
            guard let searchContents = try searchContents(identifier: identifier).first else { return }
            
            context.delete(searchContents)
            
            try context.save()
        } catch {
            throw error
        }
    }
    
    private func entitiesToContents(_ contentsEntities: [ContentsEntity]) -> [Contents] {
        var contents = [Contents]()
        
        contentsEntities.forEach {
            var content = Contents(title: $0.title ?? Constant.emptyString,
                                      body: $0.body ?? Constant.emptyString,
                                      date: $0.date,
                                      identifier: $0.identifier ?? UUID())
            
            if let weatherType = $0.weatherType,
               let weatherIconCode = $0.weatherIconCode {
                let weather = Weather(type: weatherType, iconCode: weatherIconCode)
                
                content.weather = weather
            }
            
            contents.append(content)
        }
        
        return contents
    }
    
    private func searchContents(identifier: UUID) throws -> [ContentsEntity] {
        let fetchRequest = NSFetchRequest<ContentsEntity>(entityName: ContentsEntity.description())
        fetchRequest.predicate = NSPredicate(format: Constant.identifierCondition, identifier.uuidString)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw DiaryError.invalidContents
        }
    }
}

// MARK: - Name Space
extension CoreDataManager {
    private enum Constant {
        static let container = "Diary"
        static let title = "title"
        static let body = "body"
        static let date = "date"
        static let identifier = "identifier"
        static let weatherType = "weatherType"
        static let weatherIconCode = "weatherIconCode"
        static let identifierCondition = "identifier == %@"
        static let emptyString = ""
    }
}
