//
//  CoreDataManager.swift
//  Diary
//
//  Created by 백곰,주디 on 2022/08/19.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    func updateDiary(item: DiaryItem, with diaryEntity: DiaryEntity) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        diaryEntity.setValue(item.title, forKey: "title")
        diaryEntity.setValue(item.body, forKey: "body")
        diaryEntity.setValue(item.createdAt, forKey: "createdAt")
        diaryEntity.setValue(item.id, forKey: "id")
        
        appDelegate.saveContext()
    }
    
    func fetchDiary() -> [DiaryEntity]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let diary = try context.fetch(DiaryEntity.fetchRequest())
            return diary
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func saveDiary(item: DiaryItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DiaryEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id as CVarArg)
        
        do {
            guard let diaryUpdate = try context.fetch(fetchRequest).last as? DiaryEntity else {
                let diaryEntity = DiaryEntity(context: context)
                updateDiary(item: item, with: diaryEntity)
                return
            }
            updateDiary(item: item, with: diaryUpdate)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDiary(id: UUID) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DiaryEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            guard let diaryDelete = try context.fetch(fetchRequest).last as? NSManagedObject else { return }
            context.delete(diaryDelete)
        } catch {
            print(error.localizedDescription)
        }
       
        appDelegate.saveContext()
    }
}
