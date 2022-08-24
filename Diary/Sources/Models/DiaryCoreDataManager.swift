//
//  DiaryCoreDataManager.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/24.
//

import Foundation
import CoreData
import UIKit

class DiaryCoreDataManager {
    
    static let shared = DiaryCoreDataManager()
    
    private init() {
        
    }
    
    var context: NSManagedObjectContext {
        return AppDelegate.sharedAppDelegate.persistentContainer.viewContext
    }
    
    func saveDiary(diary: DiaryItem) {
        let diaryEntity = DiaryEntity(context: context)
        diaryEntity.title = diary.title
        diaryEntity.body = diary.body
        diaryEntity.createdDate = Date(timeIntervalSince1970: diary.createdDate)
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
