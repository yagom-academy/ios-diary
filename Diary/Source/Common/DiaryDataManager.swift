//  Diary - DiaryDataManager.swift
//  Created by Ayaan, zhilly on 2022/12/26

import Foundation
import CoreData

struct DiaryDataManager: DiaryManageable {
    func add(title: String, body: String, createAt: Date) {
        let context = DiaryCoreDataStack.shared.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "DiaryData", in: context) else {
            return
        }
        
        let diary = NSManagedObject(entity: entity, insertInto: context)
        diary.setValue(title, forKey: "title")
        diary.setValue(body, forKey: "body")
        diary.setValue(createAt, forKey: "createdAt")
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func remove(_ object: NSManagedObject) {}
    
    func update(_ object: NSManagedObject) {}
}
