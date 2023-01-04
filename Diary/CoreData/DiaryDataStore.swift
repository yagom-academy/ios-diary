//
//  DiaryDataStore.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/28.
//

import CoreData
import Foundation
import os.log
import UIKit

struct DiaryDataStore {
    private enum DiaryKey {
        static let title: String = "title"
        static let body: String = "body"
        static let createdAt: String = "createdAt"
    }
    
    static let shared: DiaryDataStore = DiaryDataStore()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private let logger: Logger = Logger()
    private let context: NSManagedObjectContext
    
    private init() {
        self.context = persistentContainer.viewContext
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    func fetch(request: NSFetchRequest<Diary>) -> [DiaryData] {
        do {
            let fetchResult = try self.context.fetch(request)
            var result: [DiaryData] = []
            fetchResult.forEach {
                result.append(
                    DiaryData(
                        title: $0.title,
                        body: $0.body,
                        createdAt: $0.createdAt,
                        objectID: $0.objectID
                    )
                )
            }
            return result
        } catch {
            logger.error("\(error.localizedDescription)")
            return []
        }
    }
    
    func generateDiary() -> DiaryData? {
        let newDiary = Diary(context: context)
        saveContext()
        
        let newDiaryData = DiaryData(
            title: nil,
            body: nil,
            createdAt: Date().timeIntervalSince1970,
            objectID: newDiary.objectID
        )
        
        return newDiaryData
    }

    func updateDiary(_ diaryData: DiaryData) {
        let coreDataObject = context.object(with: diaryData.objectID)
        
        coreDataObject.setValue(diaryData.title, forKey: DiaryKey.title)
        coreDataObject.setValue(diaryData.body, forKey: DiaryKey.body)
        coreDataObject.setValue(diaryData.createdAt, forKey: DiaryKey.createdAt)

        saveContext()
    }

    func delete(objectID: NSManagedObjectID) {
        let targetObject = context.object(with: objectID)
        
        context.delete(targetObject)
        saveContext()
    }
}
