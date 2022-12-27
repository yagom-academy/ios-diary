//
//  CoreDataManager.swift
//  Diary
//
//  Created by leewonseok on 2022/12/27.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    private init() { }
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate

    lazy var context = appdelegate?.persistentContainer.viewContext
    
    let entityName = "Diary"
    
    func createDiary(data: DiaryData) {
        guard let context else {
            print("컨텍스트 불러오기 실패")
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context) else {
            print("엔티티 불러오기 실패")
            return
        }
        let diaryData = NSManagedObject(entity: entity, insertInto: context)
        diaryData.setValue(UUID(), forKey: "id")
        diaryData.setValue(data.title, forKey: "title")
        diaryData.setValue(data.body, forKey: "content")
        diaryData.setValue(data.createdAt, forKey: "createdAt")

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func readDiary() {
        
    }
    
    func updateDiary() {
        
    }
    
    func deleteDiary() {
        
    }
    
}
