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
    static let shared: DiaryDataStore = DiaryDataStore()
    
    private let entityName: String = "Diary"
    private let logger: Logger = Logger()
    private let context: NSManagedObjectContext?
    
    private init() {
        self.context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func fetch(request: NSFetchRequest<Diary>) -> [DiaryData] {
        do {
            let fetchResult = try self.context?.fetch(request)
            var result: [DiaryData] = []
            fetchResult?.forEach {
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
        guard let context = context else {
            return nil
        }
        
        let newDiary = Diary(context: context)
        
        do {
            try context.save()
            let newDiaryData = DiaryData(
                title: nil,
                body: nil,
                createdAt: Date().timeIntervalSince1970,
                objectID: newDiary.objectID
            )
            
            return newDiaryData
        } catch {
            logger.error("\(error.localizedDescription)")
            return nil
        }
    }

    @discardableResult
    func updateDiary(_ diaryData: DiaryData) -> Bool {
        guard let context = context else {
            return false
        }
        
        let coreDataObject = context.object(with: diaryData.objectID)
        
        coreDataObject.setValue(diaryData.title, forKey: "title")
        coreDataObject.setValue(diaryData.body, forKey: "body")
        coreDataObject.setValue(diaryData.createdAt, forKey: "createdAt")

        do {
            try context.save()
            return true
        } catch {
            logger.error("\(error.localizedDescription)")
            return false
        }
    }

    @discardableResult
    func delete(objectID: NSManagedObjectID) -> Bool {
        guard let context = context else {
            return false
        }
        
        let targetObject = context.object(with: objectID)
        
        context.delete(targetObject)
        do {
            try context.save()
            return true
        } catch {
            logger.error("\(error.localizedDescription)")
            return false
        }
    }
}
