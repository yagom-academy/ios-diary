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
    static let shared = CoreDataManager()
    private init() { }
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.newBackgroundContext()
    
    func create(diary: DiaryProtocol) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: "DiaryCoreData", in: context),
              let storage = NSManagedObject(entity: entity, insertInto: self.context) as? DiaryCoreData else { return }
        
        setValue(at: storage, diary: diary)
        save()
    }
    
    func readAll() -> [DiaryCoreData]? {
        guard let context = self.context else { return nil }
        
        do {
            let data = try context.fetch(DiaryCoreData.fetchRequest())
            return data
        } catch {
            return nil
        }
    }
    
    func read(key: NSManagedObjectID) -> DiaryCoreData? {
        guard let context = self.context else { return nil }
        let filter = filteredDataRequest(id: key)
        
        do {
            let data = try context.fetch(filter)
            return data.first as? DiaryCoreData
        } catch {
            return nil
        }
    }
    
    func update(key: NSManagedObjectID, diary: DiaryProtocol) {
        guard let fetchedData = read(key: key) else { return }
        
        setValue(at: fetchedData, diary: diary)
        save()
    }
    
    func deleteAll() {
        guard let context = self.context else { return }
        
        let request: NSFetchRequest<NSFetchRequestResult> = DiaryCoreData.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(id: NSManagedObjectID) {
        guard let context = self.context else { return }
        let request: NSFetchRequest<NSFetchRequestResult> = DiaryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "SELF == %@", id)
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func filteredDataRequest(id: NSManagedObjectID) -> NSFetchRequest<NSManagedObject> {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DiaryCoreData")
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", id)
        
        return fetchRequest
    }
    
    private func setValue(at target: DiaryCoreData, diary: DiaryProtocol) {
        target.setValue(diary.title, forKey: "title")
        target.setValue(diary.body, forKey: "body")
        target.setValue(diary.createdDate, forKey: "date")
        target.setValue(diary.weatherState, forKey: "weatherState")
        target.setValue(diary.icon, forKey: "icon")
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
