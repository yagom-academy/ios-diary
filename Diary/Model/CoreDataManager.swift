//
//  CoreDataManager.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/28.
//

import Foundation
import CoreData

class CoreDataMananger {
    static var shared: CoreDataMananger = CoreDataMananger()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var diaryEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "Diary", in: context)
    }
    
    func saveToContext () {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchDiaries() -> [Diary] {
        do {
            let request = Diary.fetchRequest()
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func insertDiary(_ diaryModel: DiaryModel) {
        if let diaryEntity = self.diaryEntity {
            let managedObject = NSManagedObject(entity: diaryEntity, insertInto: self.context)
            managedObject.setValue(diaryModel.title, forKey: "title")
            managedObject.setValue(diaryModel.body, forKey: "body")
            managedObject.setValue(diaryModel.createdAt, forKey: "createdAt")
            saveToContext()
        }
    }
    
    func updateDiary(_ diaryModel: DiaryModel) {
        do {
            guard let diaryID = diaryModel.id,
                  let item = try context.existingObject(with: diaryID) as? Diary else { return }
            
            item.title = diaryModel.title
            item.body = diaryModel.body
        } catch {
            print(error.localizedDescription)
        }
        
        saveToContext()
    }
    
    func fetchLastObject() -> DiaryModel {
        guard let lastDiary = fetchDiaries().last else {
            return DiaryModel()
        }
        let lastDiaryModel = DiaryModel(id: lastDiary.objectID,
                                        title: lastDiary.title ?? "",
                                        body: lastDiary.body ?? "",
                                        createdAt: lastDiary.createdAt)
        
        return lastDiaryModel
    }
}
