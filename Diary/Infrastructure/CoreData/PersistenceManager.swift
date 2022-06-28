//
//  PersistenceManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/17.
//

import UIKit
import CoreData
import OSLog

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}
    
    private(set) var diaryEntities = [DiaryEntity]()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppConstants.entityName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                os_log(.error, log: .data, "%@", "loadPersistentStores Error Occured.")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

extension PersistenceManager {
   func createData(by diary: Diary) throws {
        let request = makeRequest(by: diary.id)
        if let diaryToUpdate = try fetchResult(from: request) {
            diaryToUpdate.body = diary.body
            diaryToUpdate.title = diary.title
            diaryToUpdate.createdAt = diary.createdAt
            diaryToUpdate.id = diary.id
            diaryToUpdate.icon = diary.icon
        } else {
            let entity = DiaryEntity(context: context)
            entity.body = diary.body
            entity.title = diary.title
            entity.createdAt = diary.createdAt
            entity.id = diary.id
            entity.icon = diary.icon
        }
        try saveToContext()
    }
    
    func fetchData() throws {
        let request = DiaryEntity.fetchRequest()
        request.returnsObjectsAsFaults = false
        let fetchResult = try context.fetch(request)
        diaryEntities = fetchResult.reversed()
    }
        
    func updateData(by diary: Diary) throws {
        let request = makeRequest(by: diary.id)
        guard let diaryToUpdate = try fetchResult(from: request) else {
            return
        }
        diaryToUpdate.body = diary.body
        diaryToUpdate.title = diary.title
        diaryToUpdate.createdAt = diary.createdAt
        diaryToUpdate.id = diary.id
        diaryToUpdate.icon = diary.icon
        try saveToContext()
    }
    
    func deleteData(by object: DiaryEntity, index: Int? = nil) throws {
        if let index = index {
            diaryEntities.remove(at: index)
        }
        context.delete(object)
        try saveToContext()
    }
}

extension PersistenceManager {
    private func saveToContext() throws {
        try context.save()
    }
    
    private func makeRequest(by id: String) -> NSFetchRequest<DiaryEntity> {
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        return request
    }
    
    private func fetchResult(from request: NSFetchRequest<DiaryEntity>) throws -> DiaryEntity? {
        let fetchResult = try context.fetch(request)
        guard let diaryEntity = fetchResult.first else {
            return nil
        }
        return diaryEntity
    }
}

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier ?? ""
    static let data = OSLog(subsystem: subsystem, category: "Data")
}
