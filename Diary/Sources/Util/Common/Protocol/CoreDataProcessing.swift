//
//  CoreDataProcessing.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/24.
//

import Foundation
import CoreData

protocol CoreDataProcessing {
    var context: NSManagedObjectContext? { get set }
}

extension CoreDataProcessing {
    func getContents<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) -> [T]? {
        guard let context = context,
              let contents = try? context.fetch(request) else {
                  return nil
              }
        return contents
    }
    
    func create(text: String) {
        guard let context = context else {
            return
        }
        let diaryContents = DiaryContents(context: context)
       
        let content = text.components(separatedBy: "\n\n")
        diaryContents.title = String(content[0])
        diaryContents.body = String(content[1])
        diaryContents.createdAt = Date().timeIntervalSince1970
        diaryContents.id = UUID()
        
        do {
            try context.save()
            getContents(DiaryContents.fetchRequest())
        } catch {
            print("error!!!")
        }
    }
}
