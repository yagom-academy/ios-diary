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
    
    func fetchData() -> [DiaryData] {
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
                // TODO: Alert 구현 예정
                print("CoreData Fecth Error")
            }
        }
        return diaryDataList
    }
    
    func saveData(titleText: String,
                  contentText: String,
                  date: Date,
                  completion: (() -> Void)?) {
        guard let completion = completion else { return }
        
        guard let context = context else {
            completion()
            return
        }
        guard let entity = NSEntityDescription.entity(forEntityName: self.modelName,
                                                      in: context) else {
            completion()
            return
        }
        guard let content = NSManagedObject(entity: entity,
                                            insertInto: context) as? DiaryData else {
            completion()
            return
        }
        
        content.id = UUID()
        content.createdAt = date
        content.titleText = titleText
        content.contentText = contentText
        
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                completion()
            }
        }
        completion()
    }
    
    func updateData(id: UUID,
                    titleText: String,
                    contentText: String,
                    completion: (() -> Void)?) {
        
        guard let completion = completion else { return }
        
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
                        completion()
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    //TODO: 구현 예정
    func deleteData() {
        
    }
}
