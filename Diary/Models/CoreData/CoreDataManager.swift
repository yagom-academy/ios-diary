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
            
            // TODO: 테스트예정
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
    
    //TODO: @escaping으로 Bool값 전달하여 Alert 기능 추가 예정
    func saveData(data: (title: String, body: String, createdAt: Date),
                  completion: @escaping () -> Void) {
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
        content.title = data.title
        content.body = data.body
        content.createdAt = data.createdAt
        
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
    
    //TODO: 구현 예정
    func updateData() {
        
    }
    
    //TODO: 구현 예정
    func deleteData() {
        
    }
}
