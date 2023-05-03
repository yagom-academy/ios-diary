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
        
        container.loadPersistentStores { [weak self] (storeDescription, error) in
            if let error = error as NSError? {
                self?.showErrorAlert(error: error)
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
            showErrorAlert(error: DiaryError.fetchFailed)
            return nil
        }
    }
    
    func update(contents: Contents) {
        guard let identifier = contents.identifier else { return }
        
        let searchContents = searchContents(id: identifier).first
        
        searchContents?.setValue(contents.title, forKey: Constant.title)
        searchContents?.setValue(contents.body, forKey: Constant.body)
        
        saveContext()
    }
    
    func delete(id: UUID) {
        guard let searchContents = searchContents(id: id).first else { return }
        
        context.delete(searchContents)
        
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                showErrorAlert(error: error)
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
    
    private func searchContents(id: UUID) -> [ContentsEntity] {
        let fetchRequest = NSFetchRequest<ContentsEntity>(entityName: ContentsEntity.description())
        fetchRequest.predicate = NSPredicate(format: Constant.identifierCondition, id.uuidString)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            showErrorAlert(error: error)
            return []
        }
    }
}

extension CoreDataManager {
    private func showErrorAlert(error: Error) {
        guard let target = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alertManager = AlertManager()
        alertManager.showErrorAlert(target: target, error: error)
    }
}

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
