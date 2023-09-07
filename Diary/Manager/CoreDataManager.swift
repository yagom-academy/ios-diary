//
//  CoreDataManager.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/09/04.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func receiveFetchRequest(for uuid: String) -> NSFetchRequest<Diary> {
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid)
        
        return fetchRequest
    }
    
    // create
    func createDiary(_ textView: UITextView) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: CoreDataManager.shared.context) else {
            return
        }
        let object = NSManagedObject(entity: entity, insertInto: CoreDataManager.shared.context)
        object.setValue("타이틀틀", forKey: "title")
        object.setValue(textView.text, forKey: "body")
        object.setValue(DateFormatter.today, forKey: "createdAt")
        object.setValue(UUID().uuidString, forKey: "identifier")
        saveContext()
    }
    // fetch
    func fetchDiary(_ request: NSFetchRequest<Diary>) -> [Diary] {
        do {
            let data = try context.fetch(request)
            return data
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    // update
    // delete
    func deleteDiary(_ uuid: String) {
//        let object = diary.first!
        let fetchRequest = CoreDataManager.shared.receiveFetchRequest(for: uuid)
        
        let diary = CoreDataManager.shared.fetchDiary(fetchRequest)
        persistentContainer.viewContext.delete(diary.first!)
        saveContext()
        }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
