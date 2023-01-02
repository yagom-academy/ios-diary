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
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.diaryContainer)
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
    
    func save(_ diaryPage: DiaryPage) {
        guard searchDiary(using: diaryPage.id).first == nil else {
            return
        }
        
        let diary = Diary(context: persistentContainer.viewContext)
        diary.title = diaryPage.title
        diary.body = diaryPage.body
        diary.createdAt = diaryPage.createdAt
        diary.id = diaryPage.id
        
        saveContext()
    }
    
    func searchDiary(using id: UUID) -> [Diary] {
        let request: NSFetchRequest<Diary> = NSFetchRequest(entityName: Constant.diaryContainer)
        request.predicate = .init(format: Constant.idChecking, id.uuidString)
        
        do {
            return try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchDiaryPages() -> [DiaryPage] {
        deleteAllNoDataDiaries()
        
        var diaryList: [DiaryPage] = []
        let request = Diary.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: Constant.createdAt, ascending: false)]
       
        do {
            let fetchedData = try context.fetch(request)
            fetchedData.forEach {
                diaryList.append(DiaryPage(title: $0.title ?? Constant.empty,
                                           body: $0.body ?? Constant.empty,
                                           createdAt: $0.createdAt ?? Date(),
                                           id: $0.id ?? UUID() ))
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return diaryList
    }
    
    func update(_ diaryPage: DiaryPage) {
        guard let fetchedData = searchDiary(using: diaryPage.id).first else {
            return
        }
        
        fetchedData.title = diaryPage.title
        fetchedData.body = diaryPage.body
        
        saveContext()
    }
    
    func delete(_ diaryPage: DiaryPage) {
        guard let diaryWillDelete = searchDiary(using: diaryPage.id).first else {
            return
        }
        
        context.delete(diaryWillDelete)
        saveContext()
    }
    
    func deleteAllNoDataDiaries() {
        let request: NSFetchRequest<Diary> = NSFetchRequest(entityName: Constant.diaryContainer)
        let predicateOfTitle = NSPredicate(format: Constant.titleChecking, Constant.empty)
        let predicateOfBody = NSPredicate(format: Constant.bodyChecking, Constant.empty)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateOfTitle,
                                                                                predicateOfBody])
        
        do {
            let noDataDiaries = try context.fetch(request)
            noDataDiaries.forEach { context.delete($0) }
        } catch {
            print(error.localizedDescription)
        }

        saveContext()
    }
    
    func deleteAllDiaries() {
        let request: NSFetchRequest<Diary> = NSFetchRequest(entityName: Constant.diaryContainer)
        
        do {
            let fetchedData = try context.fetch(request)
            fetchedData.forEach { context.delete($0) }
        } catch {
            print(error.localizedDescription)
        }
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension CoreDataManager {
    
    private enum Constant {
        static let diaryContainer = "Diary"
        static let idChecking = "id = %@"
        static let titleChecking = "title = %@"
        static let bodyChecking = "body = %@"
        static let createdAt = "createdAt"
        static let empty = ""
    }
}
