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
    var dataManager: DataManager { return DataManager.shared }
        
    var context: NSManagedObjectContext? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func create(
        content: [String],
        errorHandler: @escaping (String) -> Void
    ) {
        guard let context = context else {
            return
        }
        
        let diaryContents = DiaryContents(context: context)
        diaryContents.title = content[0]
        diaryContents.body = content[1]
        diaryContents.createdAt = Date().timeIntervalSince1970
        diaryContents.id = UUID()
        
        do {
            try saveContext()
        } catch {
            errorHandler(handleError(error))
        }
    }

    func update(
        entity: DiaryContents,
        content: [String],
        errorHandler: @escaping (String) -> Void
    ) {
        let diaryContents = entity
        diaryContents.title = String(content[0])
        diaryContents.body = content[1]
        
        do {
            try saveContext()
        } catch {
            errorHandler(handleError(error))
        }
    }
    
    func delete(
        _ data: DiaryContents,
        errorHandler: @escaping (String) -> Void
    ) {
        guard let context = context else {
            return
        }
        
        context.delete(data)
        
        do {
            try saveContext()
        } catch {
            errorHandler(handleError(error))
        }
    }
    
    func getDiaryContent() -> [DiaryContents] {
        guard let context = context,
              let diaryContents = try? context.fetch(DiaryContents.fetchRequest()) else {
                  return [DiaryContents()]
        }
        
        return diaryContents
    }

    private func saveContext() throws {
        guard let context = context else {
            throw CoreDataError.noContext
        }

        guard (try? context.save()) != nil else {
            throw CoreDataError.failedToSave
        }
    }
    
    private func handleError(_ error: Error) -> String {
        switch error {
        case CoreDataError.noContext:
            return CoreDataError.noContext.localizedDescription
        case CoreDataError.failedToSave:
            return CoreDataError.failedToSave.localizedDescription
        default:
            return CoreDataError.unknown.localizedDescription
        }
    }
}
