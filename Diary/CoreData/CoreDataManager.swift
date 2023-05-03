//
//  CoreDataManager.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/28.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.container)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                AlertManager().showErrorAlert(error: DiaryError.invalidContainer)
            }
        }
        
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    
    func create(contents: Contents) {
        guard let entity = NSEntityDescription.entity(forEntityName: ContentsEntity.description(), in: context),
              let storage = NSManagedObject(entity: entity, insertInto: context) as? ContentsEntity else { return }
        
        storage.setValue(contents.title, forKey: Constant.title)
        storage.setValue(contents.body, forKey: Constant.body)
        storage.setValue(contents.date, forKey: Constant.date)
        storage.setValue(contents.identifier, forKey: Constant.identifier)
        
        saveContext()
    }
    
    func read() -> [Contents]? {
        let fetchRequest = NSFetchRequest<ContentsEntity>(entityName: ContentsEntity.description())
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            return entitiesToContents(fetchedData)
        } catch {
            AlertManager().showErrorAlert(error: DiaryError.fetchFailed)
            return nil
        }
    }
    
    func update(contents: Contents) {
        guard let identifier = contents.identifier else { return }
        
        let searchContents = searchContents(identifier: identifier).first
        
        searchContents?.setValue(contents.title, forKey: Constant.title)
        searchContents?.setValue(contents.body, forKey: Constant.body)
        
        saveContext()
    }
    
    func delete(identifier: UUID) {
        guard let searchContents = searchContents(identifier: identifier).first else { return }
        
        context.delete(searchContents)
        
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                AlertManager().showErrorAlert(error: DiaryError.saveFailed)
            }
        }
    }
    
    private func entitiesToContents(_ contentsEntities: [ContentsEntity]) -> [Contents] {
        var contents = [Contents]()
        
        contentsEntities.forEach {
            let content = Contents(title: $0.title ?? Constant.emptyString,
                                   body: $0.body ?? Constant.emptyString,
                                   date: $0.date,
                                   identifier: $0.identifier ?? UUID())
            
            contents.append(content)
        }
        
        return contents
    }
    
    private func searchContents(identifier: UUID) -> [ContentsEntity] {
        let fetchRequest = NSFetchRequest<ContentsEntity>(entityName: ContentsEntity.description())
        fetchRequest.predicate = NSPredicate(format: Constant.identifierCondition, identifier.uuidString)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            AlertManager().showErrorAlert(error: error)
            return []
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
        static let identifierCondition = "identifier == %@"
        static let emptyString = ""
    }
}
