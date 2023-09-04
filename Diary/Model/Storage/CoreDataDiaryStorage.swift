//
//  CoreDataDiaryStorage.swift
//  Diary
//
//  Created by Erick on 2023/09/04.
//

import UIKit
import CoreData

final class CoreDataDiaryStorage: DiaryStorageProtocol {
    private let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    func diaryEntrys() throws -> [DiaryEntry] {
        guard let context,
              let diaryEntitys = try context.fetch(DiaryEntity.fetchRequest()) as? [DiaryEntity] else {
            throw StorageError.loadDataFailed
        }
        
        let diaryEntrys = try diaryEntitys.map {
            try $0.diaryEntry()
        }
        
        return diaryEntrys
    }
    
    func storeDiary(_ diary: DiaryEntry) throws {
        guard let context,
              let entity = NSEntityDescription.entity(forEntityName: "DiaryEntity", in: context),
              let creationDate = DateFormatManager.timestamp(localeDateFormatter: UserDateFormatter.shared, string: diary.creationDate) else {
            throw StorageError.saveDataFailed
        }
        
        let diaryEntity = NSManagedObject(entity: entity, insertInto: context)
        diaryEntity.setValue(diary.id, forKey: "id")
        diaryEntity.setValue(diary.title, forKey: "title")
        diaryEntity.setValue(diary.body, forKey: "body")
        diaryEntity.setValue(creationDate, forKey: "creationDate")
        
        try context.save()
    }
    
}
