//
//  DiaryDAO.swift
//  Diary
//
//  Created by 김태현 on 2022/06/20.
//

import Foundation
import CoreData

final class DiaryDAO {
    static let shared = DiaryDAO()
    private init() { }
        
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func create(userData: DiaryDTO) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext) else {
            return
        }
        
        let userModel = NSManagedObject(entity: entity, insertInto: viewContext)
        
        userModel.setValue(userData.identifier, forKey: "identifier")
        userModel.setValue(userData.title, forKey: "title")
        userModel.setValue(userData.date, forKey: "date")
        userModel.setValue(userData.body, forKey: "body")
        
        save()
    }
    
    private func save() {
        guard viewContext.hasChanges else {
            return
        }
        
        do {
            try viewContext.save()
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func read() -> [DiaryDTO]? {
        let request = Diary.fetchRequest()
        guard let diary = try? viewContext.fetch(request) else {
            return nil
        }
            
        return convert(diary: diary)
    }
    
    private func convert(diary: [Diary]) -> [DiaryDTO]? {
        return diary.compactMap {
            guard let identifier = $0.identifier,
                  let title = $0.title,
                  let body = $0.body,
                  let date = $0.date else {
                return nil
            }
            
            return DiaryDTO(identifier: identifier, title: title, body: body, date: date)
        }
    }
    
    func update(userData: DiaryDTO) {
        guard let diary = getObject(identifier: userData.identifier.uuidString) else {
            return
        }
        
        diary.setValue(userData.title, forKey: "title")
        diary.setValue(userData.body, forKey: "body")
        
        save()
    }
    
    private func getObject(identifier: String) -> NSManagedObject? {
        guard let diary = fetch(identifier: identifier)?.first as? NSManagedObject else {
            return nil
        }
        
        return diary
    }
    
    private func fetch(identifier: String) -> [Diary]? {
        let request = Diary.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        
        request.predicate = predicate
        
        guard let diary = try? viewContext.fetch(request) else {
            return nil
        }
        
        return diary
    }
    
    func delete(identifier: String?) {
        guard let identifier = identifier,
              let diary = getObject(identifier: identifier) else {
            return
        }
        
        deleteContext(object: diary)
    }
    
    private func deleteContext(object: NSManagedObject) {
        viewContext.delete(object)
        save()
    }
}
