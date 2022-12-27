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
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate

    lazy var context = appdelegate?.persistentContainer.viewContext
    
    let entityName = "Diary"
    
    func createDiary(title: String?, content: String?, createdAt: Double) throws -> Diary {
        
        guard let context else { throw DataError.contextUndifined }
    
        guard let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context) else {
            throw DataError.entityUndifined
        }
        
        guard let diaryData = NSManagedObject(entity: entity, insertInto: context) as? Diary else {
            throw DataError.emptyData
        }
        
        diaryData.id = UUID()
        diaryData.title = title
        diaryData.content = content
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
        guard let context else { throw DataError.contextUndifined }
        
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
    
    func updateDiary(updatedDiary: Diary) throws {
        guard let context else { throw DataError.contextUndifined }
        
        let request = NSFetchRequest<Diary>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "id == %@", updatedDiary.id as CVarArg)
        
        do {
            var diary = try context.fetch(request).first
            
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
    }
    
    func deleteDiary(diary: Diary) throws {
        guard let context else { throw DataError.contextUndifined }
        
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
