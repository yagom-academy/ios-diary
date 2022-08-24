
//  CoreDataManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/23.
//

import UIKit
import CoreData

class CoreDataManager {
    private let persistentContainer: NSPersistentContainer = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return NSPersistentContainer() }
        let container = appDelegate.persistentContainer
        
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    init() {
        NotificationCenter.default.post(name: .didReceiveData,
                                                    object: self)
    }

    func create(myDiary: Diary) {
        let diary = DiaryEntity(context: context)
        diary.setValue(myDiary.title, forKey: "title")
        diary.setValue(myDiary.body, forKey: "body")
        diary.setValue(myDiary.createdAt, forKey: "createdAt")
        diary.setValue(myDiary.uuid, forKey: "uuid")
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetch() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DiaryEntity")
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        guard let result = try? context.fetch(fetchRequest) else { return [] }
        
        return result
    }
    
    func update(diary: Diary) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DiaryEntity")
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", diary.uuid.uuidString)
        
        do {
            guard let test = try context.fetch(fetchRequest).last as? DiaryEntity else { return }
            
            test.setValue(diary.title, forKey: "title")
            test.setValue(diary.body, forKey: "body")
            test.setValue(diary.createdAt, forKey: "createdAt")
            test.setValue(diary.uuid, forKey: "uuid")
            do {
                try context.save()
            } catch {
                print(error)
            }
        } catch { print(error) }
    }
    
    func delete() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DiaryEntity")
//        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        
        do {
            let test = try context.fetch(fetchRequest)
            guard let objectToDelete = test as? [NSManagedObject] else { return }
            for object in objectToDelete {
                context.delete(object)
            }
            do {
                try context.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}

