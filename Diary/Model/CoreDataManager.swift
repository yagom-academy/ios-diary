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
            managedObject.setValue(diaryModel.id, forKey: "id")
            managedObject.setValue(diaryModel.title, forKey: "title")
            managedObject.setValue(diaryModel.body, forKey: "body")
            managedObject.setValue(diaryModel.createdAt, forKey: "createdAt")
            saveToContext()
        }
    }
}
