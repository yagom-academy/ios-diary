//
//  CoreDataManager.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/25.
//

import Foundation
import CoreData
import UIKit.UIApplication

final class CoreDataManager {
    // MARK: - Design

    private enum NameSpace {
        static let entityName = "Diary"
        static let titleKeyName = "title"
        static let bodyKeyName = "body"
        static let createdAtKeyName = "createdAt"
        static let mainKeyName = "main"
        static let iconKeyName = "icon"
    }
    
    // MARK: - properties

    static let shared = CoreDataManager()
    
    private var appDelegate: AppDelegate? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate
    }
    
    private var context: NSManagedObjectContext? {
        appDelegate?.persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - methods

    func create(newDiary: DiaryModel) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: NameSpace.entityName, in: context)
        else { return }
        
        let diary = NSManagedObject(entity: entity, insertInto: context)
        diary.setValue(newDiary.title, forKey: NameSpace.titleKeyName)
        diary.setValue(newDiary.body, forKey: NameSpace.bodyKeyName)
        diary.setValue(newDiary.createdAt, forKey: NameSpace.createdAtKeyName)
        diary.setValue(newDiary.main, forKey: NameSpace.mainKeyName)
        diary.setValue(newDiary.icon, forKey: NameSpace.iconKeyName)
        
        appDelegate?.saveContext()
    }
    
    func read() -> [DiaryModel]? {
        guard let fetchList = try? context?.fetch(Diary.fetchRequest()) as? [Diary]
        else { return nil }
        
        var diaryList = [DiaryModel]()
        
        fetchList.forEach { diaryList.append(DiaryModel(title: $0.title,
                                                        body: $0.body,
                                                        createdAt: $0.createdAt,
                                                        main: "",
                                                        icon: ""))}
        
        return diaryList
    }
    
    func update(diary: DiaryModel) {
        guard let diaryList = try? context?.fetch(Diary.fetchRequest()),
              let diaryData = diaryList.filter({ $0.createdAt == diary.createdAt }).first
        else { return }
        
        diaryData.setValue(diary.title, forKey: NameSpace.titleKeyName)
        diaryData.setValue(diary.body, forKey: NameSpace.bodyKeyName)
        diaryData.setValue(diary.createdAt, forKey: NameSpace.createdAtKeyName)
        
        appDelegate?.saveContext()
    }
    
    func delete(createdAt: Double) {
        guard let diaryList = try? context?.fetch(Diary.fetchRequest()),
              let diaryData = diaryList.filter({ $0.createdAt == createdAt }).first
        else { return }
        
        context?.delete(diaryData)
        appDelegate?.saveContext()
    }
}
