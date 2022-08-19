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
    
    private init() {
        
    }
    
    func saveDiary(item: DiaryItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let diaryEntity = DiaryEntity(context: context)
        
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
}
