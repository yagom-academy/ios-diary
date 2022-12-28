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
        guard searchDiary(diaryPage.id).first == nil else {
            return
        }
        
        let diary = Diary(context: persistentContainer.viewContext)
        diary.title = diaryPage.title
        diary.body = diaryPage.body
        diary.createdAt = diaryPage.createdAt
        diary.id = diaryPage.id
        
        saveContext()
    }
    
    func fetchDiary() -> [DiaryPage] {
        var diaryList: [DiaryPage] = []
        do {
            let fetchedData = try context.fetch(Diary.fetchRequest())
            _ = fetchedData.map {
                diaryList.append(DiaryPage(title: $0.title ?? "",
                                           body: $0.body ?? "",
                                           createdAt: $0.createdAt ?? Date(),
                                           id: $0.id ?? UUID() ))
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return diaryList
    }
    
    func updateDiary(_ diaryPage: DiaryPage) {
        let fetchedData = searchDiary(diaryPage.id)
        fetchedData[0].title = diaryPage.title
        fetchedData[0].body = diaryPage.body
        
        saveContext()
    }
    
    func deleteDiary(_ diaryPage: DiaryPage) {
        guard let diaryWillDelete = searchDiary(diaryPage.id).first else {
            return
        }
        
        context.delete(diaryWillDelete)
        saveContext()
    }
    
    func deleteAllDiary() {
        let request: NSFetchRequest<Diary> = NSFetchRequest(entityName: "Diary")
        
        do {
            let fetchedData = try context.fetch(request)
            _ = fetchedData.map {
                context.delete($0)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        saveContext()
    }
    
    func searchDiary(_ id: UUID) -> [Diary] {
        let request: NSFetchRequest<Diary> = NSFetchRequest(entityName: "Diary")
        request.predicate = .init(format: "id = %@", id.uuidString)
        
        do {
            return try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
