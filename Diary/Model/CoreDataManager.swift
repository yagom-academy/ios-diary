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
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
    
    private func saveToContext() {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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
    
    func insertDiary(_ diaryModel: DiaryModel) {
        if let diaryEntity = self.diaryEntity {
            let managedObject = NSManagedObject(entity: diaryEntity, insertInto: self.context)
            managedObject.setValue(diaryModel.title, forKey: "title")
            managedObject.setValue(diaryModel.body, forKey: "body")
            managedObject.setValue(diaryModel.createdAt, forKey: "createdAt")
            self.saveToContext()
        }
    }
    
    func updateDiary(_ diaryModel: DiaryModel) throws {
        do {
            guard let diaryID = diaryModel.id,
                  let item = try context.existingObject(with: diaryID) as? Diary else { return }
            
            item.title = diaryModel.title
            item.body = diaryModel.body
        } catch {
            throw DiaryError.updateFailed
        }
        
        self.saveToContext()
    }
    
    func deleteDiary(_ diaryModel: DiaryModel) throws {
        do {
            guard let diaryID = diaryModel.id,
                  let item = try self.context.existingObject(with: diaryID) as? Diary else { return }
            
            self.context.delete(item)
        } catch {
            throw DiaryError.deleteFailed
        }
        
        self.saveToContext()
    }
    
    func fetchLastObject() throws -> DiaryModel {
        guard let lastDiary = try self.fetchDiaries().last else {
            throw DiaryError.fetchFailed
        }
        
        let lastDiaryModel = DiaryModel(id: lastDiary.objectID,
                                        title: lastDiary.title ?? "",
                                        body: lastDiary.body ?? "",
                                        createdAt: lastDiary.createdAt)
        
        return lastDiaryModel
    }
}
