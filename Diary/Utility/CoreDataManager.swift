//  Diary - CoreDataManager.swift
//  created by vetto on 2023/05/01

import Foundation
import CoreData

class CoreDataManger {
    static let shared = CoreDataManger()
    
    private init() {}
    
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
        return self.persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchDiary() -> [DiaryData] {
        let fetchRequest =  NSFetchRequest<DiaryData>(entityName: "DiaryData")
        
        do {
            let fetchResult = try self.context.fetch(fetchRequest)
            return fetchResult
        } catch {
            print("\(error.localizedDescription)")
            return []
        }
    }
    
    func createDiary(diaryItem: DiaryItem) {
        let entity = NSEntityDescription.entity(forEntityName: "DiaryData", in: self.context)
        
        if let entity {
            let diary = NSManagedObject(entity: entity, insertInto: self.context)
            
            diary.setValue(diaryItem.title, forKey: "title")
            diary.setValue(diaryItem.createDate, forKey: "createDate")
            diary.setValue(diaryItem.body, forKey: "body")
            diary.setValue(UUID(), forKey: "id")
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
