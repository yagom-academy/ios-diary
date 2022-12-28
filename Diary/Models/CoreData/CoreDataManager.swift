//
//  CoreDataManager.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/26.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
    
    private let modelName = "DiaryData"
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    func fetchData() -> Result<[DiaryData], DataError> {
        var diaryDataList: [DiaryData] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            
            let dataOrder = NSSortDescriptor(key: "createdAt", ascending: false)
            request.sortDescriptors = [dataOrder]
            
            do {
                if let dataList = try context.fetch(request) as? [DiaryData] {
                    diaryDataList = dataList
                }
            } catch {
                return .failure(.coreDataError)
            }
        }
        return .success(diaryDataList)
    }
    
    func saveData(titleText: String,
                  contentText: String,
                  date: Date,
                  completion: @escaping ((Result<DiaryData, DataError>) -> Void)) {
        
        guard let context = context else {
            completion(.failure(.noneDataError))
            return
        }
        guard let entity = NSEntityDescription.entity(forEntityName: self.modelName,
                                                      in: context) else {
            completion(.failure(.noneDataError))
            return
        }
        guard let content = NSManagedObject(entity: entity,
                                            insertInto: context) as? DiaryData else {
            completion(.failure(.noneDataError))
            return
        }
        
        content.id = UUID()
        content.createdAt = date
        content.titleText = titleText
        content.contentText = contentText
        
        if context.hasChanges {
            do {
                try context.save()
                completion(.success(content))
            } catch {
                completion(.failure(.noneDataError))
            }
        }
        completion(.success(content))
    }
    
    func updateData(id: UUID,
                    titleText: String,
                    contentText: String,
                    completion: @escaping (Bool) -> Void) {
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            
            do {
                guard let fetchedDatas = try context.fetch(request) as? [DiaryData] else { return }
                guard let diaryData = fetchedDatas.first else { return }
                
                diaryData.setValue(titleText, forKey: "titleText")
                diaryData.setValue(contentText, forKey: "contentText")
                if context.hasChanges {
                    do {
                        try context.save()
                        completion(true)
                    } catch {
                        completion(false)
                    }
                }
            } catch {
                completion(false)
            }
        }
    }
    //TODO: 구현 예정
    func deleteData() {
        
    }
}
