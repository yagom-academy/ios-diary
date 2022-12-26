//
//  CoreDataManager.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/26.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    static let shared: CoreDataManager = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
    
    func saveDiary(_ diaryPage: DiaryPage) {
        let diary = Diary(context: persistentContainer.viewContext)
        diary.title = diaryPage.title
        diary.body = diaryPage.body
        diary.createdAt = diaryPage.createdAt
        diary.id = diaryPage.id
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchDiary() -> [DiaryPage] {
        var diaryList: [DiaryPage] = []
        do {
            let fetchedData = try context.fetch(Diary.fetchRequest())
            _ = fetchedData.map {
                diaryList.append(DiaryPage(title: $0.title ?? "",
                                           body: $0.body ?? "",
                                           createdAt: $0.createdAt,
                                           id: $0.id ?? UUID() ))
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return diaryList
    }
    
    func updateDiary(_ diaryPage: DiaryPage) {
        let request: NSFetchRequest<Diary> = NSFetchRequest(entityName: "Diary")
        request.predicate = .init(format: "id = %@", diaryPage.id.uuidString)
        
        do {
            let fetchedData = try context.fetch(request)
            fetchedData[0].title = diaryPage.title
            fetchedData[0].body = diaryPage.body
            
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDiary(_ diaryPage: DiaryPage) {
        let request: NSFetchRequest<Diary> = NSFetchRequest(entityName: "Diary")
        request.predicate = .init(format: "id = %@", diaryPage.id.uuidString)
        
        do {
            guard let dataWillRemove = try context.fetch(request).first else {
                return
            }
            context.delete(dataWillRemove)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
