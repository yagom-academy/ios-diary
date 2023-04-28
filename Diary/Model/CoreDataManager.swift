//
//  CoreDataManager.swift
//  Diary
//
//  Created by 리지, goat on 2023/04/27.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.newBackgroundContext()
    
    func create(key:String, diary: [Diary]) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: "Diary", in: context),
              let storage = NSManagedObject(entity: entity, insertInto: self.context) as? Diary else { return }
        
        setValue(at: storage, key: key, diary: diary)
        save()
    }
    
    func read(key: String) -> Diary? {
        guard let context = self.context else { return nil }
        let filter = filteredDataRequest(key: key)
        
        do {
            let data = try context.fetch(filter)
            return data.first as? Diary
        } catch {
            return nil
        }
    }
    
    func update(key: String, diary: [Diary]) {
        guard let fetchedData = read(key: key) else { return }
        
        setValue(at: fetchedData, key: key, diary: diary)
        save()
    }
    
    func delete() {
        guard let context = self.context else { return }
        
        let request: NSFetchRequest<NSFetchRequestResult> = Diary.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func filteredDataRequest(key: String) -> NSFetchRequest<NSManagedObject> {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
        fetchRequest.predicate = NSPredicate(format: "title == %@", key)
        
        return fetchRequest
    }
    
    private func setValue(at target: Diary, key: String, diary: [Diary]) {
        guard let data = diary.first else { return }
        
        target.setValue(data.title, forKey: "title")
        target.setValue(data.body, forKey: "body")
        target.setValue(data.date, forKey: "date")
    }
    
    private func save() {
        guard let context = self.context else { return }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

