//
//  DiaryCoreDataManager.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/24.
//

import CoreData
import UIKit

class DiaryCoreDataManager {
    
    static let shared = DiaryCoreDataManager()
    
    private init() {
        
    }
    
    var context: NSManagedObjectContext {
        return AppDelegate.sharedAppDelegate.persistentContainer.viewContext
    }
    
    func saveDiary(diaryItem: DiaryItem) {
        let diaryEntity = DiaryEntity(context: context)
        diaryEntity.title = diaryItem.title
        diaryEntity.body = diaryItem.body
        diaryEntity.createdDate = Date(timeIntervalSince1970: diaryItem.createdDate)
        diaryEntity.uuid = diaryItem.uuid
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchAllDiary() -> [DiaryItem]? {
        do {
            let diaryData = try context.fetch(DiaryEntity.fetchRequest())
            
            var diaryItems: [DiaryItem] = []
            
            diaryData.forEach { diaryEntity in
                guard let title = diaryEntity.title,
                      let body = diaryEntity.body,
                      let createdDate = diaryEntity.createdDate,
                      let uuid = diaryEntity.uuid
                else {
                    return
                }
                
                let diaryItem = DiaryItem(
                    title: title,
                    body: body,
                    createdDate: createdDate.timeIntervalSince1970,
                    uuid: uuid
                )
                
                diaryItems.append(diaryItem)
            }
            return diaryItems
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func update(diaryItem: DiaryItem) {
        let diaryEntityUUID = diaryItem.uuid

        let request = NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "uuid = %@", diaryEntityUUID.uuidString)
        
        do {
            let diaryEntities = try context.fetch(request)
            let diaryEntity = diaryEntities[0]
            diaryEntity.setValue(diaryItem.title, forKey: "title")
            diaryEntity.setValue(diaryItem.body, forKey: "body")
            
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
