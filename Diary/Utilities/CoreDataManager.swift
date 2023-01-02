//
//  CoreDataManager.swift
//  Diary
//
//  Created by leewonseok on 2022/12/27.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    private init() { }
    
    lazy var context = self.persistentContainer.viewContext
    
    let entityName = "Diary"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: entityName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func createDiary(text: String, createdAt: Double) throws -> Diary {
            
        guard let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context) else {
            throw DataError.entityUndifined
        }
        
        guard let diaryData = NSManagedObject(entity: entity, insertInto: context) as? Diary else {
            throw DataError.emptyData
        }
        
        diaryData.id = UUID()
        diaryData.text = text
        diaryData.createdAt = createdAt
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw DataError.unChangedData
            }
        }
        
        return diaryData
    }
    
    func fetchDiaryList() throws -> [Diary] {
        
        var diaryList: [Diary] = []
        
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            if let fetchedDiaryList = try context.fetch(request) as? [Diary] {
                diaryList = fetchedDiaryList
            }
        } catch {
            throw DataError.emptyData
        }
        
        return diaryList
    }
    
    func updateDiary(updatedDiary: Diary) throws -> Diary? {
        
        let request = NSFetchRequest<Diary>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "id == %@", updatedDiary.id as CVarArg)
        var diary: Diary?
        
        do {
            diary = try context.fetch(request).first
            diary = updatedDiary
        } catch {
            throw DataError.emptyData
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw DataError.unChangedData
            }
        }
        
        return diary
    }
    
    func deleteDiary(diary: Diary) throws {
        
        let request = NSFetchRequest<Diary>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            if let fetchedDiary = try context.fetch(request).first {
                context.delete(fetchedDiary)
            }
        } catch {
            throw DataError.emptyData
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw DataError.unChangedData
            }
        }
    }
    
}
