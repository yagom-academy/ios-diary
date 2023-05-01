//
//  DiaryCoreDataManager.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/28.
//

import Foundation
import CoreData

final class DiaryCoreDataManager {
    static var shared: DiaryCoreDataManager = DiaryCoreDataManager()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private var diaryEntity: NSEntityDescription? {
        NSEntityDescription.entity(forEntityName: "Diary", in: context)
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createDiary(title: String?, date: String?, body: String?) {
        if let diaryEntity {
            let diary = Diary(entity: diaryEntity, insertInto: context)
            diary.setValue(title, forKey: "title")
            diary.setValue(date, forKey: "date")
            diary.setValue(body, forKey: "body")
            diary.setValue(UUID(), forKey: "id")
            
            saveContext()
        }
    }
    
    func fetchDiary() -> Result<[Diary], Error> {
        let request = Diary.fetchRequest()
        let fetchResult = Result { try self.context.fetch(request) }
        
        return fetchResult
    }
    
    func updateDiary(title: String?, date: String?, body: String?, id: UUID) {
        let request = Diary.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        request.predicate = predicate
        
        let fetchResult = try? self.context.fetch(request)
        
        guard let diary = fetchResult?.first else { return }
        
        diary.setValue(title, forKey: "title")
        diary.setValue(date, forKey: "date")
        diary.setValue(body, forKey: "body")
        
        saveContext()
    }
    
    func deleteDiary(id: UUID) {
        let request = Diary.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        request.predicate = predicate
        
        let fetchResult = try? self.context.fetch(request)
        
        guard let diary = fetchResult?.first else { return }
        
        context.delete(diary)
        saveContext()
    }
}
