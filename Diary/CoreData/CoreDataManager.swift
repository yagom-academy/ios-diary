//
//  CoreDataManager.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/22.
//
import UIKit
import CoreData

final class CoreDataManager {
    var fetchedDiaries: [Diary] = []
    static let shared = CoreDataManager()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    private init() {
        fetch()
    }
    
    func createDiary(with model: DiaryModel) {
        let newItem = Diary(context: context)
        newItem.setValue(model.title, forKey: "title")
        newItem.setValue(model.body, forKey: "body")
        newItem.setValue(model.createdAt, forKey: "createdAt")
        do {
            try context.save()
            fetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(diary: Diary) {
        context.delete(diary)
        do {
            try context.save()
            fetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func update(diary: DiaryModel, with indexPath: IndexPath) {
        guard fetchedDiaries.count - 1 >= indexPath.row else { return }
        guard fetchedDiaries[indexPath.row].title != diary.title || fetchedDiaries[indexPath.row].body != diary.body else { return }
        
        fetchedDiaries[indexPath.row].title = diary.title
        fetchedDiaries[indexPath.row].body = diary.body
        fetchedDiaries[indexPath.row].createdAt = diary.createdAt
        
        do {
            try context.save()
            fetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetch() {
        do {
            fetchedDiaries = try context.fetch(Diary.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }
}
