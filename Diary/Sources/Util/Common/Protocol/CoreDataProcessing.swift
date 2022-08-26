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
    var context: NSManagedObjectContext? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func create(
        content: [String],
        errorHandler: @escaping (CoreDataError) -> Void
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
        } catch CoreDataError.noContext {
            errorHandler(CoreDataError.noContext)
        } catch CoreDataError.failedToSave {
            errorHandler(CoreDataError.failedToSave)
        } catch {
            errorHandler(CoreDataError.unknown)
        }
    }
    
    func update(
        entity: DiaryContents,
        content: [String],
        errorHandler: @escaping (CoreDataError) -> Void
    ) {
        let diaryContents = entity
        diaryContents.title = String(content[0])
        diaryContents.body = content[1]
        
        do {
            try saveContext()
        } catch CoreDataError.noContext {
            errorHandler(CoreDataError.noContext)
        } catch CoreDataError.failedToSave {
            errorHandler(CoreDataError.failedToSave)
        } catch {
            errorHandler(CoreDataError.unknown)
        }
    }
    
    func delete(
        _ data: DiaryContents,
        errorHandler: @escaping (CoreDataError) -> Void
    ) {
        guard let context = context else {
            return
        }
        
        context.delete(data)
        
        do {
            try saveContext()
        } catch CoreDataError.noContext {
            errorHandler(CoreDataError.noContext)
        } catch CoreDataError.failedToSave {
            errorHandler(CoreDataError.failedToSave)
        } catch {
            errorHandler(CoreDataError.unknown)
        }
    }

    private func saveContext() throws {
        guard let context = context else {
            throw CoreDataError.noContext
        }

        guard (try? context.save()) != nil else {
            throw CoreDataError.failedToSave
        }
    }
}
