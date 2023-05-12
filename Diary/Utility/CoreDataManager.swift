//
//  CoreDataManager.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/01.
//

import CoreData

final class CoreDataManger {
    static let shared = CoreDataManger()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
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
        let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchResult = try self.context.fetch(fetchRequest)
            
            return fetchResult
        } catch {
            print("\(error.localizedDescription)")
            
            return []
        }
    }
    
    @discardableResult
    func createDiary(title: String = "", body: String?, icon: String?, main: String?) -> DiaryData? {
        let entity = NSEntityDescription.entity(forEntityName: "DiaryData", in: self.context)
        
        if let entity {
            let diary = NSManagedObject(entity: entity, insertInto: self.context)
            
            diary.setValue(title, forKey: "title")
            diary.setValue(body, forKey: "body")
            diary.setValue(Date().timeIntervalSince1970, forKey: "createDate")
            diary.setValue(UUID(), forKey: "id")
            diary.setValue(icon, forKey: "weatherIcon")
            diary.setValue(main, forKey: "weatherMain")
            
            do {
                try self.context.save()
                
                return diary as? DiaryData
            } catch {
                print(error.localizedDescription)
                
                return nil
            }
        }
        
        return nil
    }
    
    func updateDiary(id: UUID, title: String, body: String?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "DiaryData")
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            let result = try self.context.fetch(fetchRequest)
            guard let diary = result[0] as? NSManagedObject else { return }
            
            diary.setValue(title, forKey: "title")
            diary.setValue(Date().timeIntervalSince1970, forKey: "createDate")
            diary.setValue(body, forKey: "body")
            
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDiary(id: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "DiaryData")
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            let result = try self.context.fetch(fetchRequest)
            guard let diary = result[0] as? NSManagedObject else { return }
            
            self.context.delete(diary)
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
