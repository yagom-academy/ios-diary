//
//  CoreDataProcessing.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/24.
//

import UIKit
import CoreData

protocol CoreDataProcessing { }

extension CoreDataProcessing {
    var context: NSManagedObjectContext? { return
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func getContents<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) -> [T]? {
        guard let context = context,
              let contents = try? context.fetch(request) else {
                  return nil
              }
        return contents
    }
    
    func create(content: [String]) {
        guard let context = context else {
            return
        }
        
        let diaryContents = DiaryContents(context: context)
        diaryContents.title = content[0]
        diaryContents.body = content[1]
        diaryContents.createdAt = Date().timeIntervalSince1970
        diaryContents.id = UUID()
        
        do {
            try context.save()
        } catch {
            print("error!!!")
        }
    }
    
    func update(entity: DiaryContents, content: [String]) {
        guard let context = context else {
            return
        }
        
        let diaryContents = entity
        diaryContents.title = String(content[0])
        diaryContents.body = content[1]
        
        do {
            try context.save()
        } catch {
            print("error!!!")
        }
    }
}
