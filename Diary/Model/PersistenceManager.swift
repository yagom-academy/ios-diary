//
//  PersistenceManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/17.
//

import UIKit
import CoreData

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}
    
    private(set) var diaryEntities = [DiaryEntity]()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppConstants.entityName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                self.showErrorAlert(DiaryError.loadFail.errorDescription)
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

extension PersistenceManager {
   func createData(by diary: Diary) {
        let request = makeRequest(by: diary.id)
        if let diaryToUpdate = fetchResult(from: request) {
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
        saveToContext()
    }
    
    func fetchData() {
        do {
            let request = DiaryEntity.fetchRequest()
            request.returnsObjectsAsFaults = false
            let fetchResult = try context.fetch(request)
            diaryEntities = fetchResult.reversed()
        } catch {
            showErrorAlert(DiaryError.loadFail.errorDescription)
        }
    }
        
    func updateData(by diary: Diary) {
        let request = makeRequest(by: diary.id)
        guard let diaryToUpdate = fetchResult(from: request) else {
            return
        }
        diaryToUpdate.body = diary.body
        diaryToUpdate.title = diary.title
        diaryToUpdate.createdAt = diary.createdAt
        diaryToUpdate.id = diary.id
        diaryToUpdate.icon = diary.icon
        saveToContext()
    }
    
    func deleteData(by object: DiaryEntity, index: Int? = nil) {
        if let index = index {
            diaryEntities.remove(at: index)
        }
        context.delete(object)
        saveToContext()
    }
}

extension PersistenceManager {
    private func saveToContext() {
        do {
            try context.save()
        } catch {
            showErrorAlert(DiaryError.saveFail.errorDescription)
        }
    }
    
    private func makeRequest(by id: String) -> NSFetchRequest<DiaryEntity> {
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        return request
    }
    
    private func fetchResult(from request: NSFetchRequest<DiaryEntity>) -> DiaryEntity? {
        do {
            let fetchResult = try context.fetch(request)
            guard let diaryEntity = fetchResult.first else {
                return nil
            }
            return diaryEntity
        } catch {
            showErrorAlert(DiaryError.loadFail.errorDescription)
            return nil
        }
        
    }
}

extension PersistenceManager {
    private func showErrorAlert(_ message: String) {
        guard let topViewController = UIApplication.shared.topViewController() else { return }
        topViewController.showAlert(title: AppConstants.errorAlertTitle, message: message)
    }
}
