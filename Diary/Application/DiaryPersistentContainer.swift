//
//  DiaryPersistentContainer.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/09/08.
//

import CoreData

final class DiaryPersistentContainer: NSPersistentContainer {
    func saveContext() {
        guard viewContext.hasChanges else {
            
            return
        }
        
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func getAllItems() -> [DiaryEntity] {
        do {
            
            return try viewContext.fetch(DiaryEntity.fetchRequest())
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
            
            return []
        }
    }
    
    func deleteItem(_ item: DiaryEntity) {
        viewContext.delete(item)
        saveContext()
    }
}
