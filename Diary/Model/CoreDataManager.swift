//
//  CoreDataManager.swift
//  Diary
//
//  Created by Seoyeon Hong on 2023/05/01.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "Diary"
    
    // MARK: - Read 데이터 가져오기
    
    func getDiaryListFromCoreData() -> [Diary] {
        var diaryList = [Diary]()
        if let context = context {
            let request = NSFetchRequest<Diary>(entityName: modelName)
            let dateOrder = NSSortDescriptor(key: "createdAt", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            if let fetchedDiaryList = try? context.fetch(request) {
                diaryList = fetchedDiaryList
            }
        }
        return diaryList
    }
    
    // MARK: - Create 일기 생성하기
    
    func saveDiaryData(titleText: String?, bodyText: String?, completion: ((Diary?) -> Void)? = nil) {
        if let context = context {
            let diaryData = Diary(context: context)
            
            diaryData.title = titleText
            diaryData.body = bodyText
            diaryData.createdAt = Date().timeIntervalSince1970
            diaryData.uuid = UUID()
            
            appDelegate?.saveContext()
            NotificationCenter.default.post(name: .coreDataChanged, object: nil)
            completion?(diaryData)
        } else {
            completion?(nil)
        }
    }
    
    // MARK: - 일기 삭제하기
    
    func deleteDiaryData(data: Diary) {
        if let context = context {
            let request = NSFetchRequest<Diary>(entityName: modelName)

            request.predicate = NSPredicate(format: "uuid == %@", data.uuid as CVarArg)
            
            let fetchedDiaryList = try? context.fetch(request)
            if let targetDiaryData = fetchedDiaryList?.first {
                context.delete(targetDiaryData)
                appDelegate?.saveContext()
            }
            NotificationCenter.default.post(name: .coreDataChanged, object: nil)
        }
    }
    
    // MARK: - 일기 수정하기
    
    func updateDiaryData(newDiaryData: Diary) {
        if let context = context {
            let request = NSFetchRequest<Diary>(entityName: modelName)
            request.predicate = NSPredicate(format: "uuid == %@", newDiaryData.uuid as CVarArg)
            
            let fetchedDiaryList = try? context.fetch(request)
            if let targetDiaryData = fetchedDiaryList?.first, !targetDiaryData.isDeleted {
                targetDiaryData.title = newDiaryData.title
                targetDiaryData.body = newDiaryData.body
                
                appDelegate?.saveContext()
            }
            NotificationCenter.default.post(name: .coreDataChanged, object: nil)
        }
    }
    
}
