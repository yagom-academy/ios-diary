//
//  CoreDataManager.swift
//  Diary
//
//  Created by Seoyeon Hong on 2023/05/01.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let modelName: String = "Diary"
    
    init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // MARK: - Read 데이터 가져오기
    
    func getDiaryListFromCoreData() -> Result<[Diary], CoreDataError> {
        var diaryList = [Diary]()
        if let context = context {
            let request = NSFetchRequest<Diary>(entityName: CoreDataManager.modelName)
            let dateOrder = NSSortDescriptor(key: "createdAt", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                let fetchedDiaryList = try context.fetch(request)
                diaryList = fetchedDiaryList
                return .success(diaryList)
            } catch {
                return .failure(.fetchandLoadError)
            }
        } else {
            return .failure(.fetchandLoadError)
        }
    }
    
    // MARK: - Create 일기 생성하기
    
    func saveDiaryData(titleText: String?, bodyText: String?) -> Result<Bool, CoreDataError> {
        if let context = context {
            let diaryData = Diary(context: context)
            
            diaryData.title = titleText
            diaryData.body = bodyText
            diaryData.createdAt = Date().timeIntervalSince1970
            diaryData.uuid = UUID()
            
            appDelegate?.saveContext()
            NotificationCenter.default.post(name: .coreDataChanged, object: nil)
            return .success(true)
        } else {
            return .failure(.saveError)
        }
    }
    
    // MARK: - 일기 삭제하기
    
    func deleteDiaryData(data: Diary) -> Result<Bool, CoreDataError> {
        if let context = context {
            let request = NSFetchRequest<Diary>(entityName: CoreDataManager.modelName)
            request.predicate = NSPredicate(format: "uuid == %@", data.uuid as CVarArg)
            
            let fetchedDiaryList = try? context.fetch(request)
            if let targetDiaryData = fetchedDiaryList?.first {
                context.delete(targetDiaryData)
                appDelegate?.saveContext()
            }
            NotificationCenter.default.post(name: .coreDataChanged, object: nil)
            return .success(true)
        } else {
            return .failure(.deleteError)
        }
    }
    
    // MARK: - 일기 수정하기
    
    func updateDiaryData(newDiaryData: Diary) -> Result<Bool, CoreDataError> {
        if let context = context {
            let request = NSFetchRequest<Diary>(entityName: CoreDataManager.modelName)
            request.predicate = NSPredicate(format: "uuid == %@", newDiaryData.uuid as CVarArg)

            let fetchedDiaryList = try? context.fetch(request)
            if let targetDiaryData = fetchedDiaryList?.first, !targetDiaryData.isDeleted {
                targetDiaryData.title = newDiaryData.title
                targetDiaryData.body = newDiaryData.body
                appDelegate?.saveContext()
                NotificationCenter.default.post(name: .coreDataChanged, object: nil)
                return .success(true)
            }
        }
        return .failure(.updateError)
    }
    
}
