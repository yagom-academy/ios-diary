//
//  CoreDataManager.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/28.
//

import Foundation
import CoreData

final class CoreDataMananger {
    static let shared: CoreDataMananger = CoreDataMananger()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                print("ERROR: fail to load Persistent Stores \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    private var diaryEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "Diary", in: self.context)
    }
    
    private func saveToContext() throws {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                throw DiaryError.saveContextFailed
            }
        }
    }
    
    func fetchDiaries() throws -> [Diary] {
        do {
            let request = Diary.fetchRequest()
            let results = try self.context.fetch(request)
            return results
        } catch {
            throw DiaryError.fetchFailed
        }
    }
    
    func insert(diary: DiaryModel) throws {
        guard let diaryEntity = self.diaryEntity else { return }
        
        let managedObject = NSManagedObject(entity: diaryEntity, insertInto: self.context)
        managedObject.setValue(diary.title, forKey: "title")
        managedObject.setValue(diary.body, forKey: "body")
        managedObject.setValue(diary.weatherMain, forKey: "weatherMain")
        managedObject.setValue(diary.weatherIconID, forKey: "weatherIconID")
        managedObject.setValue(diary.createdAt, forKey: "createdAt")
        try self.saveToContext()
    }
    
    func update(diary: DiaryModel) throws {
        do {
            guard let diaryID = diary.id,
                  let item = try context.existingObject(with: diaryID) as? Diary else { return }
            
            item.title = diary.title
            item.body = diary.body
        } catch {
            throw DiaryError.updateFailed
        }
        
        try self.saveToContext()
    }
    
    func delete(diary: DiaryModel) throws {
        do {
            guard let diaryID = diary.id,
                  let item = try self.context.existingObject(with: diaryID) as? Diary else { return }
            
            self.context.delete(item)
        } catch {
            throw DiaryError.deleteFailed
        }
        
        try self.saveToContext()
    }
    
    func fetchLastObject() throws -> DiaryModel {
        guard let lastDiary = try self.fetchDiaries().last else {
            throw DiaryError.fetchFailed
        }
        
        let lastDiaryModel = DiaryModel(id: lastDiary.objectID,
                                        title: lastDiary.title ?? "",
                                        body: lastDiary.body ?? "",
                                        weatherMain: lastDiary.weatherMain ?? "",
                                        weatherIconID: lastDiary.weatherIconID ?? "",
                                        createdAt: lastDiary.createdAt)
        
        return lastDiaryModel
    }
}
